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

	lines := strings.Split(input, "\n")
	for y, line := range lines {
		for x, b := range []byte(line) {
			if isSymbol(b) {
				ans += sumPartNumbers(x, y, lines)
			}
		}
	}
	return ans
}

func sumPartNumbers(x int, y int, lines []string) int {
	sum := 0
	sum += part(x, y-1, lines, true)
	sum += part(x-1, y, lines, false)
	sum += part(x+1, y, lines, false)
	sum += part(x, y+1, lines, true)
	return sum
}

func part(x int, y int, lines []string, lookLeftRight bool) int {
	if x < 0 || y < 0 || y >= len(lines) || x >= len(lines[y]) {
		return 0
	}
	if isDigit(lines[y][x]) {
		num := numberAt(x, lines[y])
		return num
	} else if lookLeftRight {
		return part(x-1, y, lines, false) + part(x+1, y, lines, false)
	}
	return 0
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
