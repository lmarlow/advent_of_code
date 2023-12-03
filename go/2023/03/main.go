package main

import (
	_ "embed"
	"flag"
	"fmt"
	"strconv"
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

func part1(input string) int {
	ans := 0

	lines := strings.Split(input, "\n")
	for y, line := range lines {
		for x, b := range []byte(line) {
			if isSymbol(b) {
				for _, p := range parts(x, y, lines) {
					ans += p
				}
			}
		}
	}
	return ans
}

func parts(x int, y int, lines []string) []int {
	parts := []int{}
	if p := part(x, y-1, lines); p > 0 {
		parts = append(parts, p)
	} else {
		if p = part(x-1, y-1, lines); p > 0 {
			parts = append(parts, p)
		}
		if p = part(x+1, y-1, lines); p > 0 {
			parts = append(parts, p)
		}
	}
	if p := part(x-1, y, lines); p > 0 {
		parts = append(parts, p)
	}
	if p := part(x+1, y, lines); p > 0 {
		parts = append(parts, p)
	}
	if p := part(x, y+1, lines); p > 0 {
		parts = append(parts, p)
	} else {
		if p = part(x-1, y+1, lines); p > 0 {
			parts = append(parts, p)
		}
		if p = part(x+1, y+1, lines); p > 0 {
			parts = append(parts, p)
		}
	}
	return parts
}

func part(x int, y int, lines []string) int {
	if x < 0 || y < 0 || y >= len(lines) || x >= len(lines[y]) {
		return 0
	}
	if isDigit(lines[y][x]) {
		num := numberAt(x, lines[y])
		return num
	} else {
		return 0
	}
}

func numberAt(x int, line string) int {
	leftIndex, rightIndex := x, x
	for leftIndex > 0 && isDigit(line[leftIndex-1]) {
		leftIndex -= 1
	}
	for rightIndex < len(line) && isDigit(line[rightIndex]) {
		rightIndex += 1
	}
	// fmt.Println(leftIndex, x, rightIndex, line)
	num, _ := strconv.Atoi(line[leftIndex:rightIndex])
	return num
}

func isDigit(b byte) bool {
	return '0' <= b && b <= '9'
}

func isSymbol(b byte) bool {
	return !(b == '.' || isDigit(b))
}

func isGear(b byte) bool {
	return b == '*'
}

func part2(input string) int {
	ans := 0

	lines := strings.Split(input, "\n")
	for y, line := range lines {
		for x, b := range []byte(line) {
			if isGear(b) {
				if gears := parts(x, y, lines); len(gears) == 2 {
					ans += gears[0] * gears[1]
				}
			}
		}
	}
	return ans
}
