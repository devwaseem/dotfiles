import net from "node:net";

export type DeliveryResult = "delivered" | "transient_error" | "protocol_error";
export class SocketPool {
  private readonly sockets = new Set<net.Socket>();
  add(socket: net.Socket) {
    this.sockets.add(socket);
  }
  delete(socket: net.Socket) {
    this.sockets.delete(socket);
  }
  close() {
    for (const socket of this.sockets) socket.destroy();
    this.sockets.clear();
  }
}
export function sendRequestAttempt(
  endpoint: string,
  request: unknown,
  timeoutMs: number,
  pool = new SocketPool(),
): Promise<DeliveryResult> {
  return new Promise((resolve) => {
    let done = false;
    let buffer = "";
    const socket = net.createConnection(endpoint);
    pool.add(socket);
    const timeout = setTimeout(() => finish("transient_error"), timeoutMs);
    timeout.unref?.();
    function finish(result: DeliveryResult) {
      if (done) return;
      done = true;
      clearTimeout(timeout);
      pool.delete(socket);
      socket.destroy();
      resolve(result);
    }
    socket.on("error", () => finish("transient_error"));
    socket.on("connect", () => socket.write(`${JSON.stringify(request)}\n`));
    socket.on("data", (chunk) => {
      buffer += chunk.toString("utf8");
      if (buffer.length > 65_536) {
        finish("protocol_error");
        return;
      }
      const line = buffer.split("\n", 1)[0].trim();
      if (!line) return;
      try {
        const response = JSON.parse(line) as { error?: unknown };
        finish(response.error === undefined ? "delivered" : "protocol_error");
      } catch {
        if (buffer.includes("\n")) finish("protocol_error");
      }
    });
    socket.on("end", () => finish("transient_error"));
  });
}
export async function sendHerdrRequest(
  endpoint: string,
  request: unknown,
  pool: SocketPool,
): Promise<boolean> {
  const first = await sendRequestAttempt(endpoint, request, 500, pool);
  if (first === "delivered") return true;
  if (first === "protocol_error") return false;
  return (
    (await sendRequestAttempt(endpoint, request, 1500, pool)) === "delivered"
  );
}
