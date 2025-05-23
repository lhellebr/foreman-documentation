SHELL := /bin/bash
DEST := result
PORT := 5000
VERSION_LINKS := 3.15 3.14 3.13 3.12 3.11 3.10 3.9 3.8 3.7 3.6 3.5 3.4 3.3 3.2 3.1 3.0 2.5 2.4

.PHONY: all clean html web compile serve prep FORCE toc

UNAME = $(shell uname)
ifeq ($(UNAME), Linux)
CP_ARGS = -l
endif
ifeq ($(UNAME), Darwin)
CP_ARGS =
endif

all: html

prep:
	bundle install --path vendor
	cd web && bundle install --path ../vendor
	mkdir -p $(DEST)/nightly

clean:
	$(MAKE) -C guides/ clean
	rm -rf $(DEST) web/output/

html: build-foreman-el build-foreman-deb build-katello

build-%: FORCE prep
	$(MAKE) -C guides/ html BUILD=$*

web: prep
	cd web && bundle exec nanoc

compile: web html
	cp $(CP_ARGS) -nr web/output/* $(DEST)
	cp $(CP_ARGS) -nr guides/build/* $(DEST)/nightly/
	for V in $(VERSION_LINKS); do ln -sf nightly $(DEST)/$$V; done

serve: compile
	python3 -m http.server --directory ./$(DEST) $(PORT)

toc: html
	$(MAKE) -C guides/ toc

FORCE:
