import { readFile } from "node:fs/promises";

import {
  THINKING_LEVELS,
  type WorkflowPreset,
  type WorkflowPresets,
} from "./types.ts";

export interface ConfigResult {
  presets: WorkflowPresets;
  warnings: string[];
}
function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

export function parsePresetConfig(
  value: unknown,
  source: string,
): ConfigResult {
  if (!isRecord(value))
    return { presets: {}, warnings: [`${source}: expected a JSON object`] };
  const presets: WorkflowPresets = {};
  const warnings: string[] = [];
  for (const [name, raw] of Object.entries(value)) {
    if (!/^[a-z0-9][a-z0-9_-]*$/i.test(name) || !isRecord(raw)) {
      warnings.push(`${source}: ignored invalid preset "${name}"`);
      continue;
    }
    const preset: WorkflowPreset = {};
    if (raw.provider !== undefined || raw.model !== undefined) {
      if (typeof raw.provider === "string" && typeof raw.model === "string") {
        preset.provider = raw.provider;
        preset.model = raw.model;
      } else
        warnings.push(
          `${source}: preset "${name}" needs both provider and model`,
        );
    }
    if (raw.thinkingLevel !== undefined) {
      if (
        typeof raw.thinkingLevel === "string" &&
        THINKING_LEVELS.includes(raw.thinkingLevel as never)
      )
        preset.thinkingLevel =
          raw.thinkingLevel as WorkflowPreset["thinkingLevel"];
      else
        warnings.push(
          `${source}: preset "${name}" has an invalid thinkingLevel`,
        );
    }
    if (raw.tools !== undefined) {
      if (
        Array.isArray(raw.tools) &&
        raw.tools.every((tool) => typeof tool === "string")
      )
        preset.tools = [...new Set(raw.tools)];
      else warnings.push(`${source}: preset "${name}" tools must be strings`);
    }
    for (const key of ["restoreTools", "readOnly"] as const) {
      const value = raw[key];
      if (value !== undefined) {
        if (typeof value === "boolean") preset[key] = value;
        else
          warnings.push(`${source}: preset "${name}" ${key} must be boolean`);
      }
    }
    if (raw.instructions !== undefined) {
      if (typeof raw.instructions === "string")
        preset.instructions = raw.instructions.trim();
      else
        warnings.push(
          `${source}: preset "${name}" instructions must be a string`,
        );
    }
    presets[name] = preset;
  }
  return { presets, warnings };
}

async function readConfig(path: string): Promise<ConfigResult> {
  try {
    return parsePresetConfig(JSON.parse(await readFile(path, "utf8")), path);
  } catch (error) {
    if (
      error &&
      typeof error === "object" &&
      "code" in error &&
      error.code === "ENOENT"
    )
      return { presets: {}, warnings: [] };
    return {
      presets: {},
      warnings: [
        `${path}: ${error instanceof Error ? error.message : String(error)}`,
      ],
    };
  }
}

export async function loadPresetConfig(
  globalPath: string,
  projectPath?: string,
): Promise<ConfigResult> {
  const globalResult = await readConfig(globalPath);
  const projectResult = projectPath
    ? await readConfig(projectPath)
    : { presets: {}, warnings: [] };
  return {
    presets: { ...globalResult.presets, ...projectResult.presets },
    warnings: [...globalResult.warnings, ...projectResult.warnings],
  };
}
