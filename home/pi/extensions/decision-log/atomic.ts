import { randomBytes } from "node:crypto";
import { chmod, mkdir, rename, rm, stat, writeFile } from "node:fs/promises";
import { basename, dirname, join } from "node:path";

export async function replaceFileAtomically(
  target: string,
  content: string,
): Promise<void> {
  let existingMode: number | null = null;
  try {
    const info = await stat(target);
    existingMode = info.mode & 0o777;
  } catch (error) {
    if (
      !(
        error &&
        typeof error === "object" &&
        "code" in error &&
        error.code === "ENOENT"
      )
    )
      throw error;
  }

  await mkdir(dirname(target), { recursive: true });
  const temp = join(
    dirname(target),
    `.${basename(target)}.${process.pid}.${randomBytes(3).toString("hex")}.tmp`,
  );
  try {
    await writeFile(temp, content, {
      encoding: "utf8",
      mode: 0o644,
      flag: "wx",
    });
    if (existingMode !== null) await chmod(temp, existingMode);
    await rename(temp, target);
  } finally {
    await rm(temp, { force: true });
  }
}
