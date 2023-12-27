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

const (
	DOT = iota
	ROLLER
	STATIC
)

func north(platform [][]int) {
	obstructions := make([]int, len(platform))
	for j, row := range platform {
		// fmt.Println(obstructions)
		for i := range row {
			switch row[i] {
			case STATIC:
				obstructions[i] = j + 1
			case ROLLER:
				platform[j][i] = DOT
				platform[obstructions[i]][i] = ROLLER
				// fmt.Println(j, i, obstructions[i])
				obstructions[i]++
			}
		}
	}
}

func parsePlatform(input string) [][]int {
	lines := strings.Split(input, "\n")
	nRows := len(lines)
	nCols := len(lines[0])
	platform := make([][]int, nRows)
	for j, row := range lines {
		platform[j] = make([]int, nCols)
		for i := range row {
			switch row[i] {
			case '#':
				platform[j][i] = STATIC
			case 'O':
				platform[j][i] = ROLLER
			default:
				platform[j][i] = DOT
			}
		}
	}

	return platform
}

func part1(input string) (ans int) {
	platform := parsePlatform(input)
	nRows := len(platform)

	north(platform)

	for j, row := range platform {
		for i := range row {
			if row[i] == ROLLER {
				ans += nRows - j
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
