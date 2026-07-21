# Vector DB Benchmark

This directory is self-contained and can be moved into a separate repository.

## What is included

- End-to-end benchmark scripts:
  - `scripts/bench_casper.sh`
  - `scripts/bench_qdrant.sh`
- Shared script helpers: `scripts/common.sh`
- Rust source code for required helper binaries:
  - `import/` (`import` binary)
  - `goose/` (`goose-load-test` binary)
- Top-level orchestration `Makefile`.

## Prerequisites

- Rust toolchain (`cargo`)
- Bash, `curl`, `make`
- Optional: `numactl` (for NUMA pinning)
- Local server binaries placed into:
  - `casper/casper`
  - `qdrant/qdrant`
- Dataset file (default): `deep-image-96-angular.hdf5` in this directory

## Build helper binaries

```bash
make build-tools
```

This compiles:

- `import/import`
- `goose/goose-load-test`

## Run benchmarks

Casper:

```bash
make bench-casper
```

Qdrant:

```bash
make bench-qdrant
```

## Useful overrides

```bash
make bench-casper \
  HDF5=/absolute/path/to/deep-image-96-angular.hdf5 \
  USERS=32 \
  RUN_TIME_SECONDS=90 \
  SEARCH_LIMITS="10 100 1000 10000 100000"
```

All logs and benchmark outputs are saved under `results/`.
