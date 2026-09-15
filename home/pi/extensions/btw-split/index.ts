// @ts-nocheck — Pi resolves its bundled extension types at runtime.
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Key, matchesKey, truncateToWidth } from "@earendil-works/pi-tui";
import { homedir } from "node:os";
import { join } from "node:path";
import { pathToFileURL } from "node:url";

const FOCUS_KEY = "ctrl+shift+b";
const HIDE_KEY = "ctrl+alt+b";

class SplitPaneHost {
  private component: any = null;
  private overlay: any = null;
  private focusedState = false;
  private hidden = false;
  private disposed = false;
  private activeCancel: (() => void) | null = null;
  private readonly sidebarComponent = {
    render: (width: number) => this.renderPane(width),
  };

  constructor(
    private readonly pi: ExtensionAPI,
    private readonly tui: any,
    private readonly theme: any,
    private readonly keybindings: any,
    private readonly ctx: any,
    private readonly run: (ctx: any) => Promise<unknown>,
    private readonly done: (result: any) => void,
  ) {
    queueMicrotask(() => void this.start());
  }

  setOverlay(overlay: any): void {
    this.overlay = overlay;
  }

  get focused(): boolean {
    return this.focusedState;
  }

  set focused(value: boolean) {
    this.focusedState = value;
    if (this.component && "focused" in this.component) {
      this.component.focused = value;
    }
  }

  render(): string[] {
    return [""];
  }

  handleInput(data: string): void {
    if (matchesKey(data, FOCUS_KEY)) {
      this.overlay?.unfocus();
      return;
    }
    if (matchesKey(data, HIDE_KEY)) {
      this.toggleHidden();
      return;
    }
    this.component?.handleInput?.(data);
  }

  invalidate(): void {
    this.component?.invalidate?.();
  }

  dispose(): void {
    if (this.disposed) return;
    this.disposed = true;
    this.activeCancel?.();
    this.pi.events.emit("btw:sidebar", null);
  }

  focus(): void {
    if (this.hidden) this.setHidden(false);
    this.overlay?.focus();
  }

  toggleHidden(): void {
    this.setHidden(!this.hidden);
  }

  private setHidden(hidden: boolean): void {
    this.hidden = hidden;
    this.overlay?.setHidden(hidden);
    this.pi.events.emit(
      "btw:sidebar",
      hidden ? null : { component: this.sidebarComponent },
    );
    if (hidden) this.overlay?.unfocus();
    else this.overlay?.focus();
  }

  private renderPane(width: number): string[] {
    if (!this.component) return [""];
    return this.component
      .render(width)
      .map((line: string) => truncateToWidth(line, width, "", true));
  }

  private async start(): Promise<void> {
    try {
      const value = await this.run(this.createContext());
      this.done({ kind: "completed", value });
    } catch (error) {
      this.done({ kind: "failed", error });
    } finally {
      this.pi.events.emit("btw:sidebar", null);
    }
  }

  private createContext(): any {
    const ui = new Proxy(this.ctx.ui, {
      get: (target, property) => {
        if (property === "custom") {
          return (factory: any, options?: any) =>
            this.showCustom(factory, options);
        }
        const value = Reflect.get(target, property, target);
        return typeof value === "function" ? value.bind(target) : value;
      },
    });
    return new Proxy(this.ctx, {
      get: (target, property) =>
        property === "ui" ? ui : Reflect.get(target, property, target),
    });
  }

  private showCustom(factory: any, options?: any): Promise<unknown> {
    if (this.disposed)
      return Promise.reject(new Error("BTW split pane closed"));
    if (this.activeCancel) {
      return Promise.reject(new Error("BTW split pane opened overlapping UI"));
    }

    return new Promise((resolve, reject) => {
      let settled = false;
      let component: any;
      const finish = (value: unknown, error?: unknown) => {
        if (settled) return;
        settled = true;
        this.activeCancel = null;
        if (this.component === component) this.component = null;
        try {
          component?.dispose?.();
        } catch {
          // The result still wins; disposal is best effort.
        }
        this.tui.requestRender();
        error === undefined ? resolve(value) : reject(error);
      };
      this.activeCancel = () =>
        finish(undefined, new Error("BTW split pane closed"));

      Promise.resolve(
        factory(this.tui, this.theme, this.keybindings, (value: unknown) =>
          finish(value),
        ),
      )
        .then((created) => {
          if (settled) {
            created?.dispose?.();
            return;
          }
          component = created;
          this.component = created;
          if ("focused" in created) created.focused = this.focusedState;
          this.pi.events.emit("btw:sidebar", {
            component: this.sidebarComponent,
          });
          options?.onHandle?.(this.overlay);
          this.tui.requestRender();
        })
        .catch((error) => finish(undefined, error));
    });
  }
}

export default async function btwSplit(pi: ExtensionAPI) {
  const agentDir =
    process.env["PI_CODING_AGENT_DIR"] ?? join(homedir(), ".pi", "agent");
  const entry = join(
    agentDir,
    "npm",
    "node_modules",
    "@narumitw",
    "pi-btw",
    "dist",
    "index.ts",
  );
  const { default: registerBtw } = await import(pathToFileURL(entry).href);
  let activeHost: SplitPaneHost | null = null;

  const runSplitPane = async (
    ctx: any,
    run: (ctx: any) => Promise<unknown>,
  ) => {
    if (activeHost) {
      activeHost.focus();
      throw new Error("A BTW split pane is already open");
    }

    let host: SplitPaneHost | null = null;
    try {
      const outcome = await ctx.ui.custom(
        (
          tui: any,
          theme: any,
          keybindings: any,
          done: (value: any) => void,
        ) => {
          host = new SplitPaneHost(pi, tui, theme, keybindings, ctx, run, done);
          activeHost = host;
          return host;
        },
        {
          overlay: true,
          overlayOptions: { anchor: "top-right", width: 1, maxHeight: 1 },
          onHandle: (handle: any) => host?.setOverlay(handle),
        },
      );
      if (outcome.kind === "failed") throw outcome.error;
      return outcome.value;
    } finally {
      if (activeHost === host) activeHost = null;
    }
  };

  pi.registerShortcut(FOCUS_KEY, {
    description: "Switch focus to the BTW split pane",
    handler: () => activeHost?.focus(),
  });
  pi.registerShortcut(HIDE_KEY, {
    description: "Hide or show the BTW split pane",
    handler: () => activeHost?.toggleHidden(),
  });

  registerBtw(pi, { runFullscreen: runSplitPane });
}
