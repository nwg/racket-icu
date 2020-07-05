
.SUFFIXES:

ICU_MAJ := 67
ICU_MIN := 1
LIB_PREFIX := lib
LIB_SUFFIX := dylib
V := $(LIB_PREFIX)icu.$(LIB_SUFFIX)
VV := $(LIB_PREFIX)icu.$(ICU_MAJ).$(LIB_SUFFIX)
VVV := $(LIB_PREFIX)icu.$(ICU_MAJ).$(ICU_MIN).$(LIB_SUFFIX)

lib = $(foreach version,$(1),$(LIB_PREFIX)$(2).$(version).$(LIB_SUFFIX)) $(LIB_PREFIX)$(2).$(LIB_SUFFIX)

ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BUILD_DIR := $(ROOT_DIR)/build
SRC_DIR := $(ROOT_DIR)/third-party/icu/icu4c/source
INSTALL_LIB_DIR := $(ROOT_DIR)/icu/lib
CONFIG_PRODUCT := $(BUILD_DIR)/Makefile
ICU_VERSIONS := $(ICU_MAJ) $(ICU_MAJ).$(ICU_MIN)
ALL_LIBS := $(call lib,$(ICU_VERSIONS),icuuc) $(call lib,$(ICU_VERSIONS),icudata)

$(info $(ALL_LIBS))

ALL_LIBS_BUILD := $(foreach lib,$(ALL_LIBS),$(BUILD_DIR)/lib/$(lib))
ALL_LIBS_DEST := $(foreach lib,$(ALL_LIBS),$(INSTALL_LIB_DIR)/$(lib))

CPPFLAGS := -DUCONFIG_NO_COLLATION=1 -DUCONFIG_NO_COLLATION=1 -DUCONFIG_NO_FORMATTING=1 -DUCONFIG_NO_TRANSLITERATION=1

.PHONY: all
all: $(ALL_LIBS_DEST)

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

$(BUILD_DIR) $(INSTALL_LIB_DIR):
	mkdir -p $@

$(ALL_LIBS_DEST): $(INSTALL_LIB_DIR)

$(ALL_LIBS_DEST): $(ALL_LIBS_BUILD)

$(info $(ALL_LIBS_BUILD))
$(info $(ALL_LIBS_DEST))

$(ALL_LIBS_BUILD): $(CONFIG_PRODUCT)
	cd $(BUILD_DIR) && gmake && touch -h $(ALL_LIBS_BUILD)

$(CONFIG_PRODUCT): | $(BUILD_DIR)
	cd $(BUILD_DIR) && CPPFLAGS="$(CPPFLAGS)" $(SRC_DIR)/configure

$(INSTALL_LIB_DIR)/%.dylib: $(BUILD_DIR)/lib/%.dylib
	cp -a $< $@
	touch -h $@

