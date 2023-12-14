package main

import (
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

func (p IntPair) Neighbors(pipe byte) (ns []IntPair) {
	switch pipe {
	case 'S':
		ns = []IntPair{p.North(), p.East(), p.South(), p.West()}
	case '|':
		ns = []IntPair{p.North(), p.South()}
	case '7':
		ns = []IntPair{p.West(), p.South()}
	case 'F':
		ns = []IntPair{p.East(), p.South()}
	case '-':
		ns = []IntPair{p.East(), p.West()}
	case 'J':
		ns = []IntPair{p.North(), p.West()}
	case 'L':
		ns = []IntPair{p.North(), p.East()}
	default:
		ns = []IntPair{}
	}
	return
}

func (p IntPair) Next(prevXY IntPair, currentPipe byte) IntPair {
	if ns := p.Neighbors(currentPipe); ns[0] == prevXY {
		return ns[1]
	} else {
		return ns[0]
	}
}

func part1(input string) (ans int) {
	pipes := make(map[IntPair]byte)
	var startXY, prevXY, headXY IntPair
	for y, line := range strings.Split(input, "\n") {
		for x, b := range line {
			if b != '.' {
				xy := IntPair{x, y}
				pipes[xy] = byte(b)
				if b == 'S' {
					startXY = xy
					prevXY = startXY
				}
			}
		}
	}

	var currentPipe byte
	var ok bool
	if currentPipe, ok = pipes[startXY.North()]; ok && slices.Contains(north, currentPipe) {
		headXY = startXY.North()
	} else if currentPipe, ok = pipes[startXY.East()]; ok && slices.Contains(east, currentPipe) {
		headXY = startXY.East()
	} else if currentPipe, ok = pipes[startXY.South()]; ok && slices.Contains(south, currentPipe) {
		headXY = startXY.South()
	} else if currentPipe, ok = pipes[startXY.West()]; ok && slices.Contains(west, currentPipe) {
		headXY = startXY.West()
	}
	currentPipe = pipes[headXY]
	ans = 1

	for headXY != startXY {
		prevXY, headXY = headXY, headXY.Next(prevXY, currentPipe)
		currentPipe = pipes[headXY]
		ans++
	}

	ans /= 2
	return
}

func part2(input string) (ans int) {
	lines := strings.Split(input, "\n")
	ans = len(lines)
	return
}
