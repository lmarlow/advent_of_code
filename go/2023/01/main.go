package main

import (
	"bufio"
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

func part1(input string) int {
	ans := 0
	lineScanner := bufio.NewScanner(strings.NewReader(input))
	for lineScanner.Scan() {
		ans += part1LineValue(lineScanner.Text())
	}
	return ans
}

func part1LineValue(line string) int {
	var digits []byte
	for _, b := range []byte(line) {
		if '0' <= b && b <= '9' {
			digits = append(digits, b)
		}
	}
	numStr := string([]byte{digits[0], digits[len(digits)-1]})
	num, err := strconv.Atoi(numStr)
	if err != nil {
		log.Fatal(err)
	}
	return num
}

func part2(input string) int {
	ans := 0
	lineScanner := bufio.NewScanner(strings.NewReader(input))
	for lineScanner.Scan() {
		ans += part2LineValue(lineScanner.Text())
	}
	return ans
}

func part2LineValue(line string) int {
	digit1 := getDigit(line, true)
	digit2 := getDigit(line, false)
	return digit1*10 + digit2
}

func getDigit(line string, leading bool) int {
	finder := strings.HasSuffix
	if leading {
		finder = strings.HasPrefix
	}

	digits := []string{"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
	digitWords := []string{"zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}
	for n := range digits {
		if finder(line, digits[n]) || finder(line, digitWords[n]) {
			return n
		}
	}

	if leading {
		line = line[1:]
	} else {
		line = line[:len(line)-1]
	}
	return getDigit(line, leading)
}
