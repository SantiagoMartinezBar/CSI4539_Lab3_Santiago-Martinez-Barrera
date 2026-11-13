"""I replay inert files through the Ada CLI; I never evaluate their contents."""
import json
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
CASES = [
    ("01-empty", b"", False),
    ("02-one", b"A", True),
    ("03-name", b"Alice_2026-11.txt", True),
    ("04-99", b"A" * 99, True),
    ("05-100", b"B" * 100, True),
    ("06-101", b"C" * 101, False),
    ("07-160", b"D" * 160, False),
    ("08-517", b"F" * 517, False),
    ("09-format", b"%08x-%n", False),
    ("10-semicolon", b"name;echo marker", False),
    ("11-substitution", b"$(echo marker)", False),
    ("12-quote", b"' OR '1'='1", False),
    ("13-nul", b"abc\x00def", False),
    ("14-newline", b"name\n", False),
    ("15-utf8", "café".encode(), False),
    ("16-space", b"two words", False),
]


def main():
    corpus = ROOT / "corpus"
    corpus.mkdir(exist_ok=True)
    rows = []
    for name, data, accepted in CASES:
        path = corpus / f"{name}.bin"
        path.write_bytes(data)
        run = subprocess.run([str(ROOT / "bin/validate_cli"), str(path)],
                             capture_output=True, text=True, timeout=5)
        expected = f"ACCEPT {len(data)}" if accepted else "REJECT"
        assert run.returncode == (0 if accepted else 1), (name, run)
        assert run.stdout.strip() == expected, (name, run.stdout)
        rows.append({"case": name, "bytes": len(data), "ada": run.stdout.strip(),
                     "exit": run.returncode, "c": "UNRUN: reference missing"})
    missing = subprocess.run([str(ROOT / "bin/validate_cli"),
                              str(corpus / "does-not-exist")],
                             capture_output=True, text=True, timeout=5)
    assert missing.returncode == 2 and missing.stdout.startswith("ERROR ")
    evidence = ROOT / "evidence"
    evidence.mkdir(exist_ok=True)
    (evidence / "cases.json").write_text(json.dumps(rows, indent=2) + "\n")
    table = ["| Cas | Octets | Ada/SPARK observé | C |", "|---|---:|---|---|"]
    table += [f"| {r['case']} | {r['bytes']} | {r['ada']} | Non exécuté : référence manquante |" for r in rows]
    (evidence / "comparison.md").write_text("\n".join(table) + "\n")
    print(f"PASS: {len(rows)} corpus cases and missing-file safe failure")


if __name__ == "__main__":
    main()
