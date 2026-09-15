import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function herdrQuestionState(pi: ExtensionAPI) {
  if (process.env["HERDR_ENV"] !== "1") return;

  const off = pi.events.on("rpiv:ask-user:blocked", (value) => {
    if (typeof (value as { active?: unknown })?.active !== "boolean") return;
    const active = (value as { active: boolean }).active;
    pi.events.emit("herdr:blocked", {
      active,
      ...(active ? { label: "Question" } : {}),
    });
  });

  pi.on("session_shutdown", () => off());
}
