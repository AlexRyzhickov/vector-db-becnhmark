# Performance bench harness. Two end-to-end commands:
#   make bench-casper  — clean ./casper/, start it, load HDF5, build f32 then
#                        i8 indices, run goose against each, save results.
#   make bench-qdrant  — same flow for Qdrant (no-quant then int8 scalar).
#
# All artifacts (server logs, goose results) end up under ./results/.
# Server storage directories are wiped before each bench so runs are
# independent.

HERE := $(CURDIR)
HDF5 ?= $(HERE)/deep-image-96-angular.hdf5
RESULTS_DIR ?= $(HERE)/results

# Casper dev token from README. Override only if you've rotated tokens.
API_TOKEN ?= eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3OTMyOTAzNTMsImZyZWUiOnRydWV9.GxqiVw5kPzmPb25vo2CMOEwnBhjTH_GTAHeDg_nhlIQ

# Goose load knobs (forwarded to the goose binary via env).
USERS ?= 32
RUN_TIME_SECONDS ?= 90
SEARCH_LIMITS ?= 10 100 1000 10000 100000

# Optional NUMA pinning for multi-socket boxes. Empty = no pinning. Example
# for a 2-socket EPYC: SERVER_NUMA_NODE=1 LOAD_NUMA_NODE=0 (server on
# socket 1, goose+import on socket 0 so the generator doesn't steal CPU
# from the server under test).
SERVER_NUMA_NODE ?=
LOAD_NUMA_NODE ?=

.PHONY: build-tools bench-casper bench-qdrant clean help

help:
	@echo "Targets:"
	@echo "  build-tools    — compile local Rust binaries in ./import and ./goose"
	@echo "  bench-casper   — full end-to-end bench against Casper (f32 + i8)"
	@echo "  bench-qdrant   — full end-to-end bench against Qdrant (no-quant + int8)"
	@echo "  clean          — remove ./results/ and per-server storage"
	@echo ""
	@echo "Variables (override on the command line):"
	@echo "  HDF5=$(HDF5)"
	@echo "  RESULTS_DIR=$(RESULTS_DIR)"
	@echo "  USERS=$(USERS)"
	@echo "  RUN_TIME_SECONDS=$(RUN_TIME_SECONDS)"
	@echo "  SEARCH_LIMITS=$(SEARCH_LIMITS)"
	@echo "  SERVER_NUMA_NODE=$(SERVER_NUMA_NODE)  (empty = no pinning)"
	@echo "  LOAD_NUMA_NODE=$(LOAD_NUMA_NODE)    (empty = no pinning)"

build-tools:
	$(MAKE) -C $(HERE)/import build
	$(MAKE) -C $(HERE)/goose build

bench-casper: build-tools
	@HDF5=$(HDF5) RESULTS_DIR=$(RESULTS_DIR) API_TOKEN=$(API_TOKEN) \
	 USERS=$(USERS) RUN_TIME_SECONDS=$(RUN_TIME_SECONDS) \
	 SEARCH_LIMITS="$(SEARCH_LIMITS)" \
	 SERVER_NUMA_NODE="$(SERVER_NUMA_NODE)" \
	 LOAD_NUMA_NODE="$(LOAD_NUMA_NODE)" \
	 ./scripts/bench_casper.sh

bench-qdrant: build-tools
	@HDF5=$(HDF5) RESULTS_DIR=$(RESULTS_DIR) \
	 USERS=$(USERS) RUN_TIME_SECONDS=$(RUN_TIME_SECONDS) \
	 SEARCH_LIMITS="$(SEARCH_LIMITS)" \
	 SERVER_NUMA_NODE="$(SERVER_NUMA_NODE)" \
	 LOAD_NUMA_NODE="$(LOAD_NUMA_NODE)" \
	 ./scripts/bench_qdrant.sh

clean:
	rm -rf $(RESULTS_DIR) ./casper/storage ./qdrant/storage ./qdrant/snapshots
