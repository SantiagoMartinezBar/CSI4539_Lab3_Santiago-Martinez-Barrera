from pathlib import Path
import subprocess

for phase in ("before", "after"):
    command = ["gnatprove", "-P", f"proof/{phase}/diagnostic.gpr", "-u",
               "proof_copy.adb", "--mode=prove", "--level=2", "--report=all",
               "--counterexamples=on", "--checks-as-errors=on"]
    run = subprocess.run(command, capture_output=True, text=True)
    output = run.stdout + run.stderr
    Path("evidence").mkdir(exist_ok=True)
    Path(f"evidence/diagnostic-{phase}.log").write_text(
        "$ " + " ".join(command) + "\n" + output + f"\nEXIT_STATUS={run.returncode}\n")
    print(output)
    if phase == "before":
        assert run.returncode != 0 and "might fail" in output, output
        assert "Size = 101" in output, "I expected the concrete counterexample"
    else:
        assert run.returncode == 0 and "all checks proved" in output, output
