"""I preserve a command, its actual output, and its exit status as evidence."""
from pathlib import Path
import shlex
import subprocess
import sys

target, *command = sys.argv[1:]
run = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
Path(target).parent.mkdir(parents=True, exist_ok=True)
Path(target).write_text("$ " + shlex.join(command) + "\n" + run.stdout +
                        f"\nEXIT_STATUS={run.returncode}\n")
print(run.stdout, end="")
sys.exit(run.returncode)
