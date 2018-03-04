# Welcome curious developer!
#
# Make is a build tool available on most (all?) UNIX based systems. For us,
# it's a great way to organize project tasks without worrying about existing
# system dependencies.
#
# make <task>

# Environment defaults
include ./.env

build: docs libs

help:
	@ echo
	@ echo "  ${GREEN}build{RESET} – build all project artifacts."
	@ echo "  ${GREEN}web{RESET} – host a local web server."
	@ echo "  ${GREEN}docs${RESET}  – regenerate HTML docs for lessons."
	@ echo

web: all
	@ echo "${PLUS} running lessons at $(SERVER_URL)"
	@ echo "${INFO} press ctrl + c when finished"
	@ python -m SimpleHTTPServer $(PORT) > /dev/null 2>&1

libs: public/lib/babel.js public/lib/react.js public/lib/react-dom.js

public/lib/babel.js:
	@ mkdir -p $(@D)
	@ curl -s "https://unpkg.com/babel-standalone@6/babel.min.js" > $@
	@ echo "${PLUS} $@"

public/lib/react.js:
	@ mkdir -p $(@D)
	@ curl -s "https://unpkg.com/react@16.2.0/umd/react.production.min.js" > $@
	@ echo "${PLUS} $@"

public/lib/react-dom.js:
	@ mkdir -p $(@D)
	@ curl -s "https://unpkg.com/react-dom@16.2.0/umd/react-dom.production.min.js" > $@
	@ echo "${PLUS} $@"

docs: $(patsubst %.md,public/%.html,$(wildcard lessons/**/README.md) README.md)

public/%.html: %.md
	@ mkdir -p $(@D)
	@ node_modules/.bin/prettier --write $<
	@ echo "<meta charset='utf-8'>" > $(@D)/index.html
	@ cat $^ | node ./node_modules/@hunzaker/markdown >> $(@D)/index.html
	@ echo "${PLUS} $(@D)/index.html"

template: build
	@ mkdir -p public/template
	@ cp -rf public/lib public/template/lib
	@ cp lessons/scratch.html public/template/index.html
	@ cd public; zip -rqm template{.zip,}
	@ echo "${PLUS} $@.zip"

clean:
	@ git clean -fd -X
	@ echo "${INFO} clean"

.PHONY: lib clean
