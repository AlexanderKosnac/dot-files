SCRIPTS_DIR = scripts

default-target: all

clean:
	bash $(SCRIPTS_DIR)/clean.sh

install:
	bash $(SCRIPTS_DIR)/install.sh

all: clean install
