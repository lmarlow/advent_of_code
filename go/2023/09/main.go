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

func diffs(nums []int) (diffs []int) {
	diffs = make([]int, len(nums)-1)
	for i := 0; i < len(nums)-1; i++ {
		diffs[i] = nums[i+1] - nums[i]
	}
	return
}

func allZero(nums []int) bool {
	for _, n := range nums {
		if n != 0 {
			return false
		}
	}
	return true
}

func completeTailHistory(history [][]int) int {
	prev := history[len(history)-1]
	diffs := diffs(prev)
	if allZero(diffs) {
		return prev[len(prev)-1]
	} else {
		return prev[len(prev)-1] + completeTailHistory(append(history, diffs))
	}
}

func part1(input string) (ans int) {
	lines := strings.Split(input, "\n")
	for _, line := range lines {
		var history [][]int
		ans += completeTailHistory(append(history, strings2Ints(strings.Fields(line))))
	}
	return ans
}

func completeHeadHistory(history [][]int) (ans int) {
	prev := history[len(history)-1]
	diffs := diffs(prev)
	if allZero(diffs) {
		ans = prev[0]
	} else {
		ans = prev[0] - completeHeadHistory(append(history, diffs))
	}
	return
}

func part2(input string) (ans int) {
	lines := strings.Split(input, "\n")
	for _, line := range lines {
		var history [][]int
		ans += completeHeadHistory(append(history, strings2Ints(strings.Fields(line))))
	}
	return ans
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
