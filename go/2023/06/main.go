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

func part1(input string) (ans int) {
	lines := strings.Split(input, "\n")
	_, strValues, _ := strings.Cut(lines[0], ":")
	words := strings.Fields(strValues)
	times := strings2Ints(words)

	_, strValues, _ = strings.Cut(lines[1], ":")
	words = strings.Fields(strValues)
	distances := strings2Ints(words)

	words = nil

	ans = 1
	for i := range times {
		time := times[i]
		distance := distances[i]

		ways := 0
		for r := 1; r < distance; r++ {
			d := (time - r) * r
			if d > distance {
				ways++
			}
		}
		ans *= ways
	}
	return
}

func part2(input string) int {
	ans := 0

	_ = strings.Split(input, "\n")

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
	return
}
