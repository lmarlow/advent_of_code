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
	n := len(lines)

	obstructions := make([]int, len(lines[0]))

	for j, row := range lines {
		// fmt.Println(obstructions)
		for i := range row {
			switch row[i] {
			case '#':
				obstructions[i] = j + 1
			case 'O':
				ans += n - obstructions[i]
				// fmt.Println(j, i, obstructions[i])
				obstructions[i]++
			}
		}
	}

	return
}

func part2(input string) (ans int) {
	lines := strings.Split(input, "\n")

	ans = len(lines)
	return
}
