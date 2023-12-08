package main

import (
	_ "embed"
	"flag"
	"fmt"
	"log"
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
	steps := lines[0]

	network := make(map[string][]string, len(lines[2:]))
	for _, line := range lines[2:] {
		var node, left, right string
		n, err := fmt.Sscanf(line, "%3s = (%3s, %3s)", &node, &left, &right)
		if n != 3 {
			log.Fatalf("matched %d fields, not 3\n%v\n", n, err)
		}
		network[node] = []string{left, right}
	}

	currentNode := `AAA`
	for {
		for _, step := range steps {
			ans++
			switch step {
			case 'L':
				currentNode = network[currentNode][0]
			case 'R':
				currentNode = network[currentNode][1]
			default:
				log.Fatalf("Unknown step: %c", step)
			}
			if currentNode == `ZZZ` {
				return ans
			}
		}
	}
	return
}

func part2(input string) (ans int) {
	return part1(input)
}
