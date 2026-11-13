.PHONY: build test flow prove diagnostic report check
build:
	gprbuild -p -P validator.gpr
test: build
	python3 scripts/record.py evidence/unit.log bin/test_validator
	python3 scripts/record.py evidence/corpus.log python3 tests/run_cases.py
flow:
	python3 scripts/record.py evidence/flow.log gnatprove -P validator.gpr -u input_validator.adb --mode=flow --report=all --checks-as-errors=on --warnings=error
prove:
	python3 scripts/record.py evidence/prove.log gnatprove -P validator.gpr -u input_validator.adb --mode=prove --level=2 --report=all --checks-as-errors=on --warnings=error
	cp obj/gnatprove/gnatprove.out evidence/proof-summary.txt
diagnostic:
	python3 scripts/diagnostic.py
report:
	mkdir -p /tmp/lab3-font-cache
	XDG_CACHE_HOME=/tmp/lab3-font-cache pandoc report/report.md evidence/comparison.md --pdf-engine=xelatex -o report/report.pdf
check: test flow prove diagnostic
