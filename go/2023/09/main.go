package main

import (
	_ "embed"
	"flag"
	"fmt"
	"log"
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

func completedHistory(history [][]int) int {
	prev := history[len(history)-1]
	diffs := make([]int, len(prev)-1)
	for i := 0; i < len(prev)-1; i++ {
		diffs[i] = prev[i+1] - prev[i]
	}
	allZero := true
	for _, n := range diffs {
		allZero = allZero && n == 0
	}
	if allZero {
		return prev[len(prev)-1]
	} else {
		return prev[len(prev)-1] + completedHistory(append(history, diffs))
	}
}

func part1(input string) (ans int) {
	lines := strings.Split(input, "\n")
	for _, line := range lines {
		var history [][]int
		ans += completedHistory(append(history, strings2Ints(strings.Fields(line))))
	}
	return ans
}

func part2(input string) int {
	lines := strings.Split(input, "\n")
	return len(lines)
}

func strings2Ints(intStrings []string) (ints []int) {
	for _, s := range intStrings {
		i, err := strconv.Atoi(s)
		if err != nil {
			log.Fatal(err)
		}
		ints = append(ints, i)
	}
	return ints
}
