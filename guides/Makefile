SHELL := /bin/bash
SUBDIRS = $(shell ls -d doc-*)

.PHONY: all clean html linkchecker linkchecker-tryer serve subdirs $(SUBDIRS)

all: html

html: subdirs

subdirs: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C "$@" $(MAKECMDGOALS)

clean:
	@for DIR in $(SUBDIRS) ; do \
		$(MAKE) -s --directory="$$DIR" clean ; \
	done

linkchecker:
	find build -type f -name index\*html | xargs linkchecker -r1 -f common/linkchecker.ini --check-extern

linkchecker-tryer:
	find build -type f -name index\*html | xargs linkchecker --no-warnings -r1 -f common/linkchecker.ini --check-extern | ./scripts/linkchecker-tryer

ccutil: $(SUBDIRS)

toc:
	make BUILD=satellite html
	F2L=upstream_filename_to_satellite_link.json ./scripts/extract_links_toc build/**/index-satellite.html > build/toc.json
