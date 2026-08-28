import { readFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

export interface McpServerInfo {
  name: string;
  directCount: number;
  totalCount: number;
  tokenEstimate: number;
  connected: boolean;
}

interface McpTool {
  name: string;
  description?: string;
  inputSchema?: unknown;
}

interface McpServerDefinition {
  directTools?: true | string[] | false;
  excludeTools?: string[];
}

interface McpConfig {
  mcpServers?: Record<string, McpServerDefinition>;
  settings?: { directTools?: true | string[] | false };
}

interface McpCache {
  servers?: Record<string, { tools?: McpTool[] }>;
}

function getAgentDir(): string {
  return process.env["PI_AGENT_DIR"] ?? join(homedir(), ".pi", "agent");
}

function readJson(path: string): Record<string, unknown> | null {
  try {
    const value: unknown = JSON.parse(readFileSync(path, "utf-8"));
    return value && typeof value === "object" && !Array.isArray(value)
      ? (value as Record<string, unknown>)
      : null;
  } catch {
    return null;
  }
}

function estimateTokens(tool: McpTool): number {
  const schemaLen = JSON.stringify(tool.inputSchema ?? {}).length;
  const descLen = tool.description?.length ?? 0;
  return Math.ceil((tool.name.length + descLen + schemaLen) / 4) + 10;
}

export function getMcpServers(): McpServerInfo[] {
  const agentDir = getAgentDir();
  const config = readJson(join(agentDir, "mcp.json")) as McpConfig | null;
  const cache = readJson(join(agentDir, "mcp-cache.json")) as McpCache | null;
  const configuredServers = config?.mcpServers ?? {};
  const cachedServers = cache?.servers ?? {};
  const globalDirect = config?.settings?.directTools;
  const names =
    Object.keys(configuredServers).length > 0
      ? Object.keys(configuredServers)
      : Object.keys(cachedServers);

  return names.map((name) => {
    const definition = configuredServers[name] ?? {};
    const tools = cachedServers[name]?.tools ?? [];
    const toolFilter = definition.directTools ?? globalDirect ?? false;
    const excludeTools = definition.excludeTools ?? [];
    let directCount = 0;
    let tokenEstimate = 0;
    let totalCount = 0;

    for (const tool of tools) {
      if (excludeTools.includes(tool.name)) continue;
      totalCount++;
      if (
        toolFilter === true ||
        (Array.isArray(toolFilter) && toolFilter.includes(tool.name))
      ) {
        directCount++;
        tokenEstimate += estimateTokens(tool);
      }
    }

    return {
      name,
      directCount,
      totalCount,
      tokenEstimate,
      connected: tools.length > 0,
    };
  });
}
