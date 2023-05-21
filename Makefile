TARGET_DIR = $(HOME)
DOT_FILES_DIR = dot-files

FILES := $(shell find $(DOT_FILES_DIR) -type f)
TARGET_FILES := $(shell find $(DOT_FILES_DIR) -type f -printf "$(TARGET_DIR)/%P ")

LN = ln -sv

.PHONY: all files

all: files

files: $(TARGET_FILES)

$(TARGET_DIR)/%: $(DOT_FILES_DIR)/%
	@mkdir -p $(@D)

	@# If there is no file, we can directly link it
	@if [ ! -e "$@" ]; then \
		$(LN) $(realpath $<) $@; \
	fi

	@# If there is already a non-link file there, fail
	@if [ ! -L "$@" ]; then \
		echo "File $@ already exists and is a not a link" > /dev/stderr; \
		exit 1; \
	fi

	@# If there is already a link there, assert that they point to the same location
	@if [ "$(shell readlink -f "$@")" = "$(shell realpath "$<")" ]; then \
		echo "Link $@ already exists but points to a different location" > /dev/stderr; \
		exit 1; \
	fi
