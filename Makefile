# Welcome curious developer!
#
# Make is a build tool available on most (all?) UNIX based systems. For us,
# it's a great way to organize project tasks without worrying about existing
# system dependencies.
#
# make <task>

# Environment defaults
include ./.env

all: docs lib

lib: lib/babel.js lib/react.js lib/react-dom.js
	@ cp -rf $@ lessons/0-intro/
	@ cp -rf $@ lessons/1-notes-app/
	@ cp -rf $@ lessons/2-jsx/
	@ cp -rf $@ lessons/3-events-and-state/
	@ cp -rf $@ lessons/4-pascal-bonus/
	@ echo "${INFO} All libraries are up to date!"

lib/babel.js:
	@ mkdir -p lib
	@ curl -s "https://unpkg.com/babel-standalone@6/babel.min.js" > $@
	@ echo "${PLUS} $@"

lib/react.js:
	@ mkdir -p lib
	@ curl -s "https://unpkg.com/react@16.2.0/umd/react.production.min.js" > $@
	@ echo "${PLUS} $@"

lib/react-dom.js:
	@ mkdir -p lib
	@ curl -s "https://unpkg.com/react-dom@16.2.0/umd/react-dom.production.min.js" > $@
	@ echo "${PLUS} $@"

help:
	@ echo
	@ echo "  ${GREEN}start${RESET} – host a local web server."
	@ echo "  ${GREEN}all${RESET} – build all project artifacts."
	@ echo "  ${GREEN}docs${RESET}  – create pretty docs for lessons."
	@ echo "  ${GREEN}lib${RESET} – update libraries."
	@ echo

start:
	@ echo "${PLUS} running lessons at $(SERVER_URL)"
	@ echo "${INFO} press ctrl + c when finished"
	@ python -m SimpleHTTPServer $(PORT) > /dev/null 2>&1

docs: $(patsubst %.md,%.html,$(wildcard lessons/**/README.md) README.md)

%.html: %.md
	@ node_modules/.bin/prettier --write $<
	@ echo "<meta charset='utf-8'>" > $(@D)/index.html
	@ cat $^ | node ./node_modules/@hunzaker/markdown >> $(@D)/index.html
	@ echo "${PLUS} $(@D)/index.html"

clean:
	@ git clean -fd -X
	@ echo "${INFO} clean"

.PHONY: lib clean
