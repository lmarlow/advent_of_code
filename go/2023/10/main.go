package main

import (
	_ "embed"
	"flag"
	"fmt"
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

var (
	north = []byte{'|', '7', 'F'}
	east  = []byte{'-', 'J', '7'}
	south = []byte{'|', 'L', 'J'}
	west  = []byte{'-', 'L', 'F'}
)

type IntPair struct {
	X int
	Y int
}

func (p IntPair) North() IntPair {
	return IntPair{p.X, p.Y - 1}
}

func (p IntPair) East() IntPair {
	return IntPair{p.X + 1, p.Y}
}

func (p IntPair) South() IntPair {
	return IntPair{p.X, p.Y + 1}
}

func (p IntPair) West() IntPair {
	return IntPair{p.X - 1, p.Y}
}

func (p IntPair) Neighbors() []IntPair {
	return []IntPair{p.North(), p.East(), p.South(), p.West()}
}

func part1(input string) (ans int) {
	pipes := make(map[IntPair]byte)
	var s, p1, p2 IntPair
	for y, line := range strings.Split(input, "\n") {
		for x, b := range line {
			if b != '.' {
				xy := IntPair{x, y}
				pipes[xy] = byte(b)
				if b == 'S' {
					s = xy
				}
			}
		}
	}

	ans = len(pipes)
	return
}

func part2(input string) (ans int) {
	lines := strings.Split(input, "\n")
	ans = len(lines)
	return
}
