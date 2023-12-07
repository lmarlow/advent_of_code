package main

import (
	"cmp"
	_ "embed"
	"flag"
	"fmt"
	"log"
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

const (
	high = iota
	pair
	twoPair
	three
	fullHouse
	four
	five
)

var cardValues map[byte]int

func init() {
	cards := []byte{'A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2'}
	slices.Reverse(cards)
	cardValues = make(map[byte]int, len(cards))
	for i, b := range cards {
		cardValues[b] = i
	}
}

type hand struct {
	cards string
	bid   int
}

func (h *hand) handType() int {
	runeSeen := make(map[rune]bool, len(h.cards))
	var counts []int
	for _, c := range h.cards {
		if _, ok := runeSeen[c]; !ok {
			runeSeen[c] = true
			counts = append(counts, strings.Count(h.cards, string(c)))
		}
	}
	slices.Sort(counts)
	slices.Reverse(counts)

	switch {
	case counts[0] == 5:
		return five
	case counts[0] == 4:
		return four
	case counts[0] == 3 && counts[1] == 2:
		return fullHouse
	case counts[0] == 3:
		return three
	case counts[0] == 2 && counts[1] == 2:
		return twoPair
	case counts[0] == 2:
		return pair
	default:
		return high
	}
}

func sortHand(a, b hand) int {
	if cmpType := cmp.Compare(a.handType(), b.handType()); cmpType != 0 {
		return cmpType
	}

	for i := range a.cards {
		if cmpCard := cmp.Compare(cardValues[a.cards[i]], cardValues[b.cards[i]]); cmpCard != 0 {
			return cmpCard
		}
	}
	log.Fatalf("hands are equal %s == %s\n", a.cards, b.cards)
	return 0
}

// Input:
// 32T3K 765
// T55J5 684
// KK677 28
// KTJJT 220
// QQQJA 483
func part1(input string) (ans int) {
	var hands []hand
	for _, line := range strings.Split(input, "\n") {
		var cards string
		var bid int
		n, err := fmt.Sscanf(line, "%s %d", &cards, &bid)
		if n != 2 {
			log.Fatalf("Could not parse line as poker hand: %q\n%d: %v\n", line, n, err)
		}

		hands = append(hands, hand{cards, bid})
	}

	slices.SortFunc(hands, sortHand)

	ans = 0
	for i, h := range hands {
		rank := i + 1
		// fmt.Printf("%4d %s %4d\n", rank, h.cards, h.bid)
		ans += h.bid * rank
	}

	return
}

func part2(input string) (ans int) {
	return
}
