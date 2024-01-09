cwd = $(abspath .)
PAD_DAY = $(shell basename $(cwd))
DAY = $(shell echo $(PAD_DAY) | sed -e 's/^0*//')
YEAR = $(shell dirname $(cwd) | xargs basename)

.PHONY: test
test: input.txt
	go test -v ./...

input.txt:
	@curl --silent https://adventofcode.com/$(YEAR)/day/$(DAY)/input --cookie "session=${COOKIE}" --output $@

puzzle.html:
	@curl --silent https://adventofcode.com/$(YEAR)/day/$(DAY) --cookie "session=${COOKIE}" --output $@

puzzle.md:
	@curl --silent https://adventofcode.com/$(YEAR)/day/$(DAY) --cookie "session=${COOKIE}" | \
		htmlq article | pandoc --from html --to gfm --output $@
