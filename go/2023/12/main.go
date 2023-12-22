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

type arrangement struct {
	springs string
	counts  string
}

func newArrangement(springs string, counts []int) *arrangement {
	countsStr := make([]string, len(counts))
	for _, c := range counts {
		countsStr = append(countsStr, fmt.Sprintf("%d", c))
	}
	return &arrangement{springs, strings.Join(countsStr, ",")}
}

func arrangements(springs string, counts []int, inGroup bool, seen map[arrangement]int) int {
	arr := newArrangement(springs, counts)
	if ans, ok := seen[*arr]; ok {
		return ans
	}
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

	ans := 0
	switch {
	case s == '#' && count > 0:
		ans = arrangements(rest, append([]int{count - 1}, restCounts...), true, seen)
	case s == '.' && inGroup && count == 0:
		ans = arrangements(rest, restCounts, false, seen)
	case s == '.' && !inGroup:
		ans = arrangements(rest, counts, false, seen)
	case s == '?' && !inGroup:
		working := arrangements(rest, counts, false, seen)
		broken := 0
		if count > 0 {
			broken = arrangements(rest, append([]int{count - 1}, restCounts...), true, seen)
		} else if count == 0 && len(restCounts) > 0 {
			broken = arrangements(rest, append([]int{restCounts[0] - 1}, restCounts[1:]...), true, seen)
		}
		ans = working + broken
	case s == '?' && inGroup:
		if count == 0 {
			ans = arrangements(rest, restCounts, false, seen)
		} else {
			ans = arrangements(rest, append([]int{count - 1}, restCounts...), true, seen)
		}
	default:
		ans = 0
	}
	seen[*arr] = ans
	return ans
}

func lineArrangements(line string) int {
	springs, countsStr, _ := strings.Cut(line, " ")
	var counts []int
	for _, s := range strings.Split(countsStr, ",") {
		n, _ := strconv.Atoi(s)
		counts = append(counts, n)
	}

	return arrangements(springs, counts, false, make(map[arrangement]int))
}

func part1(input string) (ans int) {
	lines := strings.Split(input, "\n")

	for _, line := range lines {
		ans += lineArrangements(line)
	}

	return
}

func expand(line string) string {
	springs, countsStr, _ := strings.Cut(line, " ")
	return fmt.Sprintf("%s?%s?%s?%s?%s %s,%s,%s,%s,%s", springs, springs, springs, springs, springs, countsStr, countsStr, countsStr, countsStr, countsStr)
}

func part2(input string) (ans int) {
	lines := strings.Split(input, "\n")

	for _, line := range lines {
		expanded := expand(line)
		ans += lineArrangements(expanded)
	}

	return
}
