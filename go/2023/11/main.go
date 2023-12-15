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
		ans := part2(input, 1000000)
		fmt.Println("Output:", ans)
	} else {
		ans := part1(input)
		fmt.Println("Output:", ans)
	}
}

type IntTuple struct {
	X int
	Y int
}

func part1(input string) int {
	return sumDistances(input, 2)
}

func sumDistances(input string, growthFactor int) (ans int) {
	lines := strings.Split(input, "\n")

	hashXIndexes := make(map[int]bool)
	hashYIndexes := make(map[int]bool)
	var hashes []*IntTuple
	for y, line := range lines {
		for x, r := range line {
			if r == '#' {
				hashXIndexes[x] = true
				hashYIndexes[y] = true
				hashes = append(hashes, &IntTuple{x, y})
			}
		}
	}

	var emptyRowIndexes, emptyColumnIndexes []int
	for y := 0; y < len(lines); y++ {
		if _, ok := hashYIndexes[y]; !ok {
			emptyRowIndexes = append(emptyRowIndexes, y)
		}
	}
	for x := 0; x < len(lines[0]); x++ {
		if _, ok := hashXIndexes[x]; !ok {
			emptyColumnIndexes = append(emptyColumnIndexes, x)
		}
	}

	expandUniverse(emptyRowIndexes, emptyColumnIndexes, hashes, growthFactor)

	for i, hashLocation := range hashes[:len(hashes)-1] {
		for j := i + 1; j < len(hashes); j++ {
			deltaX := hashLocation.X - hashes[j].X
			deltaY := hashLocation.Y - hashes[j].Y
			if deltaX < 0 {
				deltaX *= -1
			}
			if deltaY < 0 {
				deltaY *= -1
			}
			ans += deltaX + deltaY
		}
	}

	return
}

func expandUniverse(emptyRowIndexes, emptyColumnIndexes []int, galaxyLocations []*IntTuple, growthFactor int) {
	for _, g := range galaxyLocations {
		adjustX, _ := slices.BinarySearch(emptyColumnIndexes, g.X)
		adjustY, _ := slices.BinarySearch(emptyRowIndexes, g.Y)
		g.X += adjustX * (growthFactor - 1)
		g.Y += adjustY * (growthFactor - 1)
	}
}

func part2(input string, growthFactor int) (ans int) {
	return sumDistances(input, growthFactor)
}
