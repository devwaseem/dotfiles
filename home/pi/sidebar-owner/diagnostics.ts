// @ts-nocheck — Pi resolves Node built-ins at runtime.
import { relative } from "node:path";

export interface LensDiagnostic {
  severity?: string;
  message?: string;
  line?: number;
  col?: number;
  rule?: string;
}

interface LensFile {
  path: string;
  diagnostics: LensDiagnostic[];
  truncated?: boolean;
}

interface LensPayload {
  v: number;
  source: string;
  seq: number;
  files: LensFile[];
}

export class DiagnosticState {
  private files = new Map<string, LensFile>();
  private lastSeq = 0;

  clear(): void {
    this.files.clear();
    this.lastSeq = 0;
  }

  replace(payload: unknown): boolean {
    if (!isLensPayload(payload) || payload.seq <= this.lastSeq) return false;
    this.lastSeq = payload.seq;
    for (const file of payload.files) {
      this.files.set(file.path, file);
    }
    return true;
  }

  get errorCount(): number {
    let count = 0;
    for (const file of this.files.values()) {
      count += file.diagnostics.filter((d) => d.severity === "error").length;
    }
    return count;
  }

  get hasTruncatedErrors(): boolean {
    return [...this.files.values()].some(
      (file) =>
        file.truncated === true &&
        file.diagnostics.filter((d) => d.severity === "error").length === 12,
    );
  }

  formatErrors(cwd: string | undefined): string {
    const files = [...this.files.values()]
      .map((file) => ({
        ...file,
        diagnostics: file.diagnostics
          .filter((d) => d.severity === "error")
          .sort(
            (a, b) =>
              (a.line ?? 0) - (b.line ?? 0) || (a.col ?? 0) - (b.col ?? 0),
          ),
      }))
      .filter((file) => file.diagnostics.length > 0)
      .sort((a, b) => a.path.localeCompare(b.path));

    if (files.length === 0) return "No errors.";

    return files
      .map((file) => {
        const name = cwd ? relative(cwd, file.path) || "." : file.path;
        const rows = file.diagnostics.map((diagnostic) => {
          const line = diagnostic.line ?? 0;
          const col = diagnostic.col ?? 0;
          const location = line > 0 ? `${line}:${col > 0 ? col : 1}` : "?:?";
          const rule = diagnostic.rule ? ` [${clean(diagnostic.rule)}]` : "";
          return `  ${location}  ${clean(diagnostic.message ?? "Unknown error")}${rule}`;
        });
        if (file.truncated && file.diagnostics.length === 12) {
          rows.push("  … more errors may exist");
        }
        return `${clean(name)} (${file.diagnostics.length})\n${rows.join("\n")}`;
      })
      .join("\n\n");
  }
}

function clean(value: string): string {
  return value
    .replace(/[\x00-\x1f\x7f-\x9f]/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

function isLensPayload(value: unknown): value is LensPayload {
  if (!value || typeof value !== "object") return false;
  const payload = value as Record<string, unknown>;
  if (
    payload["v"] !== 1 ||
    payload["source"] !== "pi-lens" ||
    typeof payload["seq"] !== "number" ||
    !Number.isFinite(payload["seq"]) ||
    !Array.isArray(payload["files"])
  ) {
    return false;
  }
  return payload["files"].every((file) => {
    if (!file || typeof file !== "object") return false;
    const entry = file as Record<string, unknown>;
    return (
      typeof entry["path"] === "string" &&
      Array.isArray(entry["diagnostics"]) &&
      entry["diagnostics"].every(
        (diagnostic) => diagnostic !== null && typeof diagnostic === "object",
      )
    );
  });
}
