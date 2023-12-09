package main

import (
	_ "embed"
	"flag"
	"fmt"
	"log"
	"math/big"
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
}

func lcm(nums []int) uint64 {
	var bigNums []*big.Int
	for _, n := range nums {
		bigNums = append(bigNums, big.NewInt(int64(n)))
	}

	gcd := bigNums[0]

	for i := 1; i < len(bigNums); i++ {
		gcd = new(big.Int).GCD(nil, nil, gcd, bigNums[i])
	}

	lcm := bigNums[0]
	for i := 1; i < len(bigNums); i++ {
		prod := lcm.Mul(lcm, bigNums[i])
		lcm = prod.Div(prod, gcd)
	}

	return lcm.Uint64()
}

func part2(input string) int {
	lines := strings.Split(input, "\n")
	steps := lines[0]

	network := make(map[string][]string, len(lines[2:]))
	var currentNodes []string
	for _, line := range lines[2:] {
		var node, left, right string
		n, err := fmt.Sscanf(line, "%3s = (%3s, %3s)", &node, &left, &right)
		if n != 3 {
			log.Fatalf("matched %d fields, not 3\n%v\n", n, err)
		}
		network[node] = []string{left, right}
		if strings.HasSuffix(node, `A`) {
			currentNodes = append(currentNodes, node)
		}
	}

	ans := 0
	nodeSteps := make([]int, len(currentNodes))
	for {
		for _, step := range steps {
			ans++
			zCount := 0
			for i, currentNode := range currentNodes {
				if nodeSteps[i] > 0 {
					zCount++
					continue
				}
				switch step {
				case 'L':
					currentNodes[i] = network[currentNode][0]
				case 'R':
					currentNodes[i] = network[currentNode][1]
				default:
					log.Fatalf("Unknown step: %c", step)
				}
				if strings.HasSuffix(currentNodes[i], `Z`) {
					nodeSteps[i] = ans
					zCount++
				}
			}
			if zCount == len(currentNodes) {
				return int(lcm(nodeSteps))
			}
		}
	}
}
