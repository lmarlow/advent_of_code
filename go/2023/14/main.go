package main

import (
	"bytes"
	_ "embed"
	"flag"
	"fmt"
	"strings"

	"golang.org/x/crypto/blake2b"
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

const (
	DOT = iota
	ROLLER
	STATIC
)

type Platform [][]byte

func (p Platform) Clone() Platform {
	c := make([][]byte, len(p))
	for i, bs := range p {
		c[i] = bytes.Clone(bs)
	}
	return c
}

func north(platform Platform) {
	obstructions := make([]int, len(platform))
	for j, row := range platform {
		// fmt.Println(obstructions)
		for i := range row {
			switch row[i] {
			case STATIC:
				obstructions[i] = j + 1
			case ROLLER:
				platform[j][i] = DOT
				platform[obstructions[i]][i] = ROLLER
				// fmt.Println(j, i, obstructions[i])
				obstructions[i]++
			}
		}
	}
}

func south(platform Platform) {
	obstructions := make([]int, len(platform))
	for i := range obstructions {
		obstructions[i] = len(obstructions) - 1
	}
	for j := len(platform) - 1; j >= 0; j-- {
		// fmt.Println(obstructions)
		row := platform[j]
		for i := range row {
			switch row[i] {
			case STATIC:
				obstructions[i] = j - 1
			case ROLLER:
				// fmt.Println(j, i, obstructions[i])
				platform[j][i] = DOT
				platform[obstructions[i]][i] = ROLLER
				// fmt.Println(j, i, obstructions[i])
				obstructions[i]--
			}
		}
	}
}

func west(platform Platform) {
	obstructions := make([]int, len(platform[0]))
	for j, row := range platform {
		// fmt.Println(obstructions)
		for i := range row {
			switch row[i] {
			case STATIC:
				obstructions[j] = i - 1
			case ROLLER:
				platform[j][i] = DOT
				fmt.Println(i, j, len(obstructions), obstructions[j])
				platform[obstructions[j]][i] = ROLLER
				// fmt.Println(j, i, obstructions[i])
				obstructions[j]--
			}
		}
	}
}

func east(platform Platform) {
	obstructions := make([]int, len(platform[0]))
	for i := range obstructions {
		obstructions[i] = len(obstructions) - 1
	}
	for j, row := range platform {
		// fmt.Println(obstructions)
		for i := len(obstructions) - 1; i >= 0; i-- {
			switch row[i] {
			case STATIC:
				obstructions[j] = i + 1
			case ROLLER:
				platform[j][i] = DOT
				platform[obstructions[j]][i] = ROLLER
				// fmt.Println(j, i, obstructions[i])
				obstructions[j]++
			}
		}
	}
}

func parsePlatform(input string) Platform {
	lines := strings.Split(input, "\n")
	nRows := len(lines)
	nCols := len(lines[0])
	platform := make([][]byte, nRows)
	for j, row := range lines {
		platform[j] = make([]byte, nCols)
		for i := range row {
			switch row[i] {
			case '#':
				platform[j][i] = STATIC
			case 'O':
				platform[j][i] = ROLLER
			default:
				platform[j][i] = DOT
			}
		}
	}

	return platform
}

func score(platform Platform) (ans int) {
	nRows := len(platform)
	for j, row := range platform {
		for i := range row {
			if row[i] == ROLLER {
				ans += nRows - j
			}
		}
	}

	return
}

func part1(input string) (ans int) {
	platform := parsePlatform(input)

	north(platform)

	ans = score(platform)
	return
}

func (p Platform) String() string {
	var b strings.Builder
	for _, row := range p {
		for i := range row {
			switch row[i] {
			case ROLLER:
				b.WriteByte('O')
			case STATIC:
				b.WriteByte('#')
			default:
				b.WriteByte('.')
			}
		}
		b.WriteByte('\n')
	}
	return b.String()
}

func cycle(platform Platform) {
	fmt.Println(platform)
	north(platform)
	fmt.Println(platform)
	west(platform)
	fmt.Println(platform)
	south(platform)
	fmt.Println(platform)
	east(platform)
	fmt.Println(platform)
}

func hash(platform Platform) string {
	h, _ := blake2b.New256(nil)
	for _, v := range platform {
		h.Write(v)
	}
	return string(h.Sum(nil))
}

func part2(input string) (ans int) {
	platform := parsePlatform(input)

	seen := make(map[string]int)
	var states []Platform

	cycleStart, cycleEnd := 0, 0
	for {
		cycleEnd++
		cycle(platform)
		states = append(states, platform.Clone())
		h := hash(platform)
		if x, ok := seen[h]; ok {
			cycleStart = x
			fmt.Println("state seen before", cycleEnd, cycleStart)
			break
		}
		seen[h] = cycleEnd

		// fmt.Println(i + 1)
		//
		// print(platform)
		if cycleEnd%10000000 == 0 {
			fmt.Println(cycleEnd)
		}
	}

	cycleLength := cycleEnd - cycleStart
	maxCycles := 1000000000

	idx := (maxCycles-cycleStart)%cycleLength + cycleStart
	platform = states[idx]

	ans = score(platform)
	return
}
