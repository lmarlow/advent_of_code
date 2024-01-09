cwd = $(abspath .)
YEAR ?= $(shell basename $(cwd))
DAY ?= $(shell date +%-d)
PAD_DAY ?= $(shell printf "%02d" $(DAY))
DAY_DIR ?= $(PAD_DAY)

GEN_FILES = $(patsubst tmpl/%,$(DAY_DIR)/%,$(wildcard tmpl/*))

$(DAY_DIR)/input.txt: | $(DAY_DIR)
	@curl --silent https://adventofcode.com/$(YEAR)/day/$(DAY)/input --cookie "session=${COOKIE}" --output $@

$(DAY_DIR)/puzzle.md: | $(DAY_DIR)
	@curl --silent https://adventofcode.com/$(YEAR)/day/$(DAY) --cookie "session=${COOKIE}" | \
		htmlq article | pandoc --from html --to gfm --output $@

gen: $(GEN_FILES) $(DAY_DIR)/input.txt $(DAY_DIR)/puzzle.md
	@git diff-index --quiet HEAD && echo No changes || \
		(git commit --quiet --message "$(YEAR)-$(PAD_DAY) boilerplate" && echo Changes committed)

$(DAY_DIR)/%: tmpl/% | $(DAY_DIR)
	@cp $< $@
	@git add $@
	@echo Generated $@

$(DAY_DIR):
	@mkdir $(DAY_DIR)
