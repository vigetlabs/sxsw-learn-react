# Welcome curious developer!
#
# Make is a build tool available on most (all?) UNIX based systems. For us,
# it's a great way to organize project tasks without worrying about existing
# system dependencies.
#
# make <task>

# Environment defaults
include ./.env

all: docs starter-kit

help:
	@ echo
	@ echo "  ${GREEN}all${RESET} – build all project artifacts."
	@ echo "  ${GREEN}web${RESET} – host a local web server."
	@ echo "  ${GREEN}docs${RESET}  – regenerate HTML docs for lessons."
	@ echo

web: docs
	@ echo "${PLUS} running lessons at $(SERVER_URL)"
	@ echo "${INFO} press ctrl + c when finished"
	@ php -S localhost:$(PORT) -t public

docs: $(patsubst lessons/%.md,public/%.html,$(wildcard lessons/*.md))

public/%.html: lessons/%.md
	@ echo "<meta charset='utf-8'>" > $@
	@ cat $^ | node ./node_modules/@hunzaker/markdown >> $@
	@ echo "${PLUS} $@"

starter-kit:
	@ cd public; zip -q starter-kit{.zip,}
	@ echo "${PLUS} $@.zip"

clean:
	@ git clean -fdXq
	@ echo "${INFO} clean"

.PHONY: lib clean
