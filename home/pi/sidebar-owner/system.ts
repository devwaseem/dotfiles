import os from "node:os";

interface CpuTimes {
  idle: number;
  total: number;
}

function cpuTimes(): CpuTimes {
  let idle = 0;
  let total = 0;
  for (const cpu of os.cpus()) {
    idle += cpu.times.idle;
    total += Object.values(cpu.times).reduce((sum, value) => sum + value, 0);
  }
  return { idle, total };
}

export function createSystemSampler(): () => {
  cpuPercent: number | null;
  memoryPercent: number;
} {
  let previous = cpuTimes();
  return () => {
    const current = cpuTimes();
    const idleDelta = current.idle - previous.idle;
    const totalDelta = current.total - previous.total;
    previous = current;
    return {
      cpuPercent:
        totalDelta > 0
          ? Math.max(0, Math.min(100, 100 * (1 - idleDelta / totalDelta)))
          : null,
      memoryPercent: 100 * (1 - os.freemem() / os.totalmem()),
    };
  };
}
