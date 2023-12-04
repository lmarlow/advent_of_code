package main

import (
	"bufio"
	_ "embed"
	"flag"
	"fmt"
	"slices"
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
	for _, line := range lines {
		_, cards, _ := strings.Cut(line, ":")
		strWinners, strPlayed, _ := strings.Cut(cards, "|")
		winners := words(strWinners)
		played := words(strPlayed)
		score := 0
		for _, p := range played {
			if slices.Contains(winners, p) {
				if score == 0 {
					score = 1
				} else {
					score = score << 1
				}
			}
		}
		ans += score
	}
	return ans
}

func words(s string) []string {
	wordList := []string{}
	scanner := bufio.NewScanner(strings.NewReader(s))
	scanner.Split(bufio.ScanWords)
	for scanner.Scan() {
		wordList = append(wordList, scanner.Text())
	}
	return wordList
}

func part2(input string) int {
	ans := 0

	// lines := strings.Split(input, "\n")
	// for y, line := range lines {
	// }
	return ans
}
