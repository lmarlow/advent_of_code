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
	north = []rune{'|', '7', 'F'}
	east  = []rune{'-', 'J', '7'}
	south = []rune{'|', 'L', 'J'}
	west  = []rune{'-', 'L', 'F'}
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

func (p IntPair) Neighbors(pipe rune) (ns []IntPair) {
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

func (p IntPair) Next(prevXY IntPair, currentPipe rune) IntPair {
	if ns := p.Neighbors(currentPipe); ns[0] == prevXY {
		return ns[1]
	} else {
		return ns[0]
	}
}

func part1(input string) (ans int) {
	pipes := make(map[IntPair]rune)
	var startXY, prevXY, headXY IntPair
	for y, line := range strings.Split(input, "\n") {
		for x, b := range line {
			if b != '.' {
				xy := IntPair{x, y}
				pipes[xy] = b
				if b == 'S' {
					startXY = xy
					prevXY = startXY
				}
			}
		}
	}

	var currentPipe rune
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

func determineS(path []IntPair) (s rune) {
	last, start, first := path[len(path)-1], path[0], path[1]
	// fmt.Println(last, first)
	if (last.North() == start && start.North() == first) || (last.South() == start && start.South() == first) {
		s = '|'
	} else if (last.East() == start && start.East() == first) || (last.West() == start && start.West() == first) {
		s = '-'
	} else if (last.East() == start && start.North() == first) || (last.South() == start && start.West() == first) {
		s = 'J'
	} else if (last.East() == start && start.South() == first) || (last.North() == start && start.West() == first) {
		s = '7'
	} else if (last.West() == start && start.South() == first) || (last.North() == start && start.East() == first) {
		s = 'F'
	} else if (last.South() == start && start.East() == first) || (last.West() == start && start.North() == first) {
		s = 'L'
	}
	return
}

func part2(input string) (ans int) {
	pipes := make(map[IntPair]rune)
	var startXY, prevXY, headXY IntPair
	lines := strings.Split(input, "\n")
	for y, line := range lines {
		for x, b := range line {
			if b != '.' {
				xy := IntPair{x, y}
				pipes[xy] = b
				if b == 'S' {
					startXY = xy
					prevXY = startXY
				}
			}
		}
	}

	var currentPipe rune
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

	loopIndex := 0
	xy2Index := map[IntPair]int{startXY: loopIndex}
	path := []IntPair{startXY}
	for headXY != startXY {
		prevXY, headXY = headXY, headXY.Next(prevXY, currentPipe)
		currentPipe = pipes[headXY]
		loopIndex++
		xy2Index[prevXY] = loopIndex
		path = append(path, prevXY)
	}

	dimX, dimY := len(lines[0]), len(lines)
	sPipe := determineS(path)
	// fmt.Printf("S = %c\n", sPipe)

	for y := 0; y < dimY; y++ {
		crossings := 0
		beginCrossing := '.'
		for x := 0; x < dimX; x++ {
			xy := IntPair{x, y}
			if _, ok := xy2Index[xy]; ok {
				r := rune(lines[y][x])
				if xy == startXY {
					r = sPipe
				}
				switch r {
				case 'F', 'L':
					beginCrossing = r
				case '|':
					crossings++
					beginCrossing = '.'
				case 'J':
					if beginCrossing == 'F' {
						crossings++
						beginCrossing = '.'
					}
				case '7':
					if beginCrossing == 'L' {
						crossings++
						beginCrossing = '.'
					}
				}
				// fmt.Print(string(pipes[xy]))
			} else {
				if crossings%2 == 1 {
					// fmt.Print("I")
					ans++
				} else {
					// fmt.Print("O")
				}
			}
		}
		// fmt.Println()
	}

	return
}
