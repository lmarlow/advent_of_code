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

func arrangements(springs string, counts []int, inGroup bool, acc int) int {
	if springs == "" {
		if len(counts) == 0 || (len(counts) == 1 && counts[0] == 0) {
			return 1
		} else {
			return 0
		}
	}

	s, rest := springs[0], springs[1:]
	count := 0
	var restCounts []int
	if len(counts) > 0 {
		count = counts[0]
		restCounts = counts[1:]
	}

	switch {
	case s == '#' && count > 0:
		return arrangements(rest, append([]int{count - 1}, restCounts...), true, acc)
	case s == '.' && inGroup && count == 0:
		return arrangements(rest, restCounts, false, acc)
	case s == '.' && !inGroup:
		return arrangements(rest, counts, false, acc)
	case s == '?' && !inGroup:
		working := arrangements(rest, counts, false, acc)
		broken := 0
		if count > 0 {
			broken = arrangements(rest, append([]int{count - 1}, restCounts...), true, acc)
		} else if count == 0 && len(restCounts) > 0 {
			broken = arrangements(rest, append([]int{restCounts[0] - 1}, restCounts[1:]...), true, acc)
		}
		return working + broken
	case s == '?' && inGroup:
		if count == 0 {
			return arrangements(rest, restCounts, false, acc)
		} else {
			return arrangements(rest, append([]int{count - 1}, restCounts...), true, acc)
		}
	default:
		return 0
	}
}

func part1(input string) (ans int) {
	lines := strings.Split(input, "\n")

	for _, line := range lines {
		springs, countsStr, _ := strings.Cut(line, " ")
		var counts []int
		for _, s := range strings.Split(countsStr, ",") {
			n, _ := strconv.Atoi(s)
			counts = append(counts, n)
		}
		ans += arrangements(springs, counts, false, 0)
	}

	return
}

func part2(input string) (ans int) {
	lines := strings.Split(input, "\n")

	ans = len(lines)
	return
}
