package main

import (
	_ "embed"
	"flag"
	"fmt"
	"strings"
)

//go:embed input.txt
var input string

func init() {
	// do this in init (not main) so test file has same input
	input = strings.TrimRight(input, "\n")
	if len(input) == 0 {
		panic("empty input.txt file")
	}
}

func main() {
	var part int
	flag.IntVar(&part, "part", 1, "part 1 or 2")
	flag.Parse()
	fmt.Println("Running part", part)

	if part == 2 {
		ans := part2(input)
		fmt.Println("Output:", ans)
	} else {
		ans := part1(input)
		fmt.Println("Output:", ans)
	}
}

func part1(input string) (ans int) {
	lines := strings.Split(input, "\n")
	return len(lines)
}

func part2(input string) int {
	lines := strings.Split(input, "\n")
	return len(lines)
}
