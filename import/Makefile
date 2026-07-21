PACKAGE := import-rs
BIN := import
HERE := $(CURDIR)
CARGO_TARGET_DIR := $(HERE)/target
TARGET_DIR := $(CARGO_TARGET_DIR)/release

# Vectors source (override on the command line)
BIN_PATH      ?= /root/dir/perf/data.bin
HDF5_PATH     ?= /root/dir/perf/deep-image-96-angular.hdf5
HDF5_DATASET  ?= train

# Casper HTTP endpoint and target collection
BASE_URL      ?= http://localhost:7222
COLLECTION    ?= test_collection

# Qdrant HTTP endpoint and target collection
QDRANT_BASE_URL   ?= http://localhost:6333
QDRANT_COLLECTION ?= deep-image-96-noindex
QDRANT_BATCH_SIZE ?= 512

.PHONY: build clean import-bin import-hdf5 import-bin-qdrant import-hdf5-qdrant

build:
	cargo build --manifest-path $(HERE)/Cargo.toml --release --target-dir $(CARGO_TARGET_DIR)
	cp $(TARGET_DIR)/$(BIN) $(HERE)/$(BIN)

clean:
	rm -f $(HERE)/$(BIN)

$(HERE)/$(BIN):
	$(MAKE) build

# Import vectors from a binary file
import-bin: $(HERE)/$(BIN)
	@if [ -z "$(BIN_PATH)" ]; then \
		echo "Error: BIN_PATH is required"; \
		echo "Usage: make import-bin BIN_PATH=path/to/vectors.bin"; \
		exit 1; \
	fi
	@echo "Importing vectors (Rust) from: $(BIN_PATH)"
	$(HERE)/$(BIN) $(BIN_PATH) --base-url $(BASE_URL) --collection $(COLLECTION)

# Import vectors from an HDF5 file (e.g. ann-benchmarks datasets)
import-hdf5: $(HERE)/$(BIN)
	@if [ -z "$(HDF5_PATH)" ]; then \
		echo "Error: HDF5_PATH is required"; \
		echo "Usage: make import-hdf5 HDF5_PATH=path/to/file.hdf5 [HDF5_DATASET=train]"; \
		exit 1; \
	fi
	@echo "Importing HDF5 vectors from: $(HDF5_PATH) (dataset=$(HDF5_DATASET))"
	$(HERE)/$(BIN) $(HDF5_PATH) \
		--format hdf5 \
		--dataset $(HDF5_DATASET) \
		--base-url $(BASE_URL) \
		--collection $(COLLECTION)

# Import vectors from a binary file into a Qdrant collection
import-bin-qdrant: $(HERE)/$(BIN)
	@if [ -z "$(BIN_PATH)" ]; then \
		echo "Error: BIN_PATH is required"; \
		exit 1; \
	fi
	@echo "Importing vectors (Rust) into Qdrant collection '$(QDRANT_COLLECTION)' from: $(BIN_PATH)"
	$(HERE)/$(BIN) $(BIN_PATH) \
		--backend qdrant \
		--base-url $(QDRANT_BASE_URL) \
		--collection $(QDRANT_COLLECTION) \
		--batch-size $(QDRANT_BATCH_SIZE) \
		--quiet

# Import vectors from an HDF5 file into a Qdrant collection
import-hdf5-qdrant: $(HERE)/$(BIN)
	@if [ -z "$(HDF5_PATH)" ]; then \
		echo "Error: HDF5_PATH is required"; \
		exit 1; \
	fi
	@echo "Importing HDF5 vectors into Qdrant collection '$(QDRANT_COLLECTION)' from: $(HDF5_PATH) (dataset=$(HDF5_DATASET))"
	$(HERE)/$(BIN) $(HDF5_PATH) \
		--format hdf5 \
		--dataset $(HDF5_DATASET) \
		--backend qdrant \
		--base-url $(QDRANT_BASE_URL) \
		--collection $(QDRANT_COLLECTION) \
		--batch-size $(QDRANT_BATCH_SIZE) \
		--quiet
