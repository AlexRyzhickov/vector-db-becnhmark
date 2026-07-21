# Vector DB Benchmark

This repository is a high-load benchmark harness for Casper and Qdrant.
Compared versions: Casper `v0.1.0` vs Qdrant `v1.17.0`.
The load-testing layer in this project is built on top of the [Goose](https://github.com/tag1consulting/goose) library.

All logs and benchmark outputs are saved under `results/`.

## Download and extract

Download:

```bash
wget https://github.com/AlexRyzhickov/vector-db-becnhmark/releases/download/v0.1.0/vector-db-becnhmark-unknown-linux-gnu.tar.gz
```

Extract:

```bash
tar -xzf vector-db-becnhmark-unknown-linux-gnu.tar.gz
```

## Run Benchmarks

Casper:

```bash
make bench-casper
```

Qdrant:

```bash
make bench-qdrant
```

## Run benchmarks with advanced params

### NUMA pinning

Casper:

```bash
make bench-casper SERVER_NUMA_NODE=1 LOAD_NUMA_NODE=0
```

Qdrant:

```bash
make bench-qdrant SERVER_NUMA_NODE=1 LOAD_NUMA_NODE=0
```

### Concurrency examples

Casper with higher concurrency:

```bash
make bench-casper USERS=64
```

Qdrant with higher concurrency:

```bash
make bench-qdrant USERS=64
```

Casper with both concurrency and NUMA pinning:

```bash
make bench-casper USERS=64 SERVER_NUMA_NODE=1 LOAD_NUMA_NODE=0
```

Qdrant with both concurrency and NUMA pinning:

```bash
make bench-qdrant USERS=64 SERVER_NUMA_NODE=1 LOAD_NUMA_NODE=0
```

### Overrides example

```bash
make bench-casper \
  HDF5=./deep-image-96-angular.hdf5 \
  USERS=32 \
  RUN_TIME_SECONDS=90 \
  SEARCH_LIMITS="10 100 1000 10000 100000"
```

## Prerequisites

- Bash, `curl`, `make`
- Optional: Rust toolchain (`cargo`). Only needed to build helper binaries from source
- Optional: `numactl` (for NUMA pinning)
- Dataset file (default): `deep-image-96-angular.hdf5` in this directory
