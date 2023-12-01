package main

import (
	"bufio"
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
	lineScanner := bufio.NewScanner(strings.NewReader(input))
	for lineScanner.Scan() {
		var digits []byte
		for _, b := range []byte(lineScanner.Text()) {
			if '0' <= b && b <= '9' {
				digits = append(digits, b)
			}
		}
		numStr := string([]byte{digits[0], digits[len(digits)-1]})
		num, _ := strconv.ParseInt(numStr, 10, 32)
		ans = ans + int(num)
	}
	return ans
}

func part2(input string) int {
	return 0
}
