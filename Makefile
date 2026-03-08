OLS_DIR := $(HOME)/.local/share/OLS

BIN := $(OLS_DIR)/bin
LIB := $(OLS_DIR)/lib
SBIN := $(OLS_DIR)/sbin
PLUG := $(OLS_DIR)/plugins
ASSETS := $(OLS_DIR)/assets
LOGS := $(OLS_DIR)/logs.log

SRC_BIN := src/bin
SRC_LIB := src/lib
SRC_ASSETS := assets

.PHONY: all install uninstall reinstall

all: install

install:
	@echo "Installing OLS to $(OLS_DIR)"
	@install -d $(BIN) $(LIB) $(SBIN) $(PLUG) $(ASSETS)
	@touch $(LOGS)
	@cp -r $(SRC_BIN)/* $(BIN)/ 2>/dev/null || true
	@cp -r $(SRC_LIB)/* $(LIB)/ 2>/dev/null || true
	@cp -r $(SRC_ASSETS)/* $(ASSETS)/ 2>/dev/null || true
	@chmod 755 $(BIN)/* $(LOGS)  2>/dev/null || true
	@chmod 700 $(LIB)/ 2>/dev/null || true
	@echo "OLS installed successfully."

uninstall:
	@rm -rf $(OLS_DIR)
	@echo "OLS removed."

reinstall: uninstall install
