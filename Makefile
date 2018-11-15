.PHONY: build
build: nightly dev-packages
	pipenv run pyo3-pack build

.PHONY: build-release
build-release: nightly dev-packages
	pipenv run pyo3-pack build --release

.PHONY: nightly
nightly:
	rustup override set nightly

.PHONY: install
install: nightly dev-packages
	pipenv run pyo3-pack develop

.PHONY: clean
clean:
	pipenv --rm || true
	cargo clean

.PHONY: dev-packages
dev-packages:
	pipenv install --dev

.PHONY: test
test: dev-packages install quicktest

.PHONY: quicktest
quicktest:
	pipenv run pytest tests


.PHONY: bench
bench:
	pipenv run pytest benchmarks

.PHONY: bench-compare
bench-compare:
	pipenv run pytest benchmarks --compare
	
.PHONY: plot
plot:
	pipenv run pytest benchmarks --compare --benchmark-json=benchmark.json
	@echo "Rendering plots from benchmarks"
	pipenv run python benchmarks/histogram.py

.PHONY: profile
profile: nightly
	cd profiling && pipenv run cargo build --release
	perf script | stackcollapse-perf.pl | c++filt | flamegraph.pl > flame.svg

