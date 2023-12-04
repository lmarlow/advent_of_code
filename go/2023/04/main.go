package main

import (
	"bufio"
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

func part1(input string) int {
	ans := 0

	lines := strings.Split(input, "\n")
	for _, line := range lines {
		_, cards, _ := strings.Cut(line, ":")
		strWinners, strPlayed, _ := strings.Cut(cards, "|")
		winners := words(strWinners)
		played := words(strPlayed)
		if numMatched := numMatches(winners, played); numMatched > 0 {
			score := 1 << (numMatched - 1)
			ans += score
		}
	}
	return ans
}

func numMatches(winningNumbers []string, playedNumbers []string) int {
	count := 0
	for _, p := range playedNumbers {
		if slices.Contains(winningNumbers, p) {
			count += 1
		}
	}
	return count
}

func words(s string) []string {
	wordList := []string{}
	scanner := bufio.NewScanner(strings.NewReader(s))
	scanner.Split(bufio.ScanWords)
	for scanner.Scan() {
		wordList = append(wordList, scanner.Text())
	}
	return wordList
}

type Card struct {
	WinningNumbers []string
	PlayedNumbers  []string
	ID             int
	NumMatches     int
	Count          int
}

func NewCard(line string) *Card {
	cardID, cards, _ := strings.Cut(line, ":")
	var id int
	_, _ = fmt.Sscanf(cardID, "Card %d", &id)
	strWinners, strPlayed, _ := strings.Cut(cards, "|")
	winners := words(strWinners)
	played := words(strPlayed)

	return &Card{
		ID:             id,
		WinningNumbers: winners,
		PlayedNumbers:  played,
		NumMatches:     numMatches(winners, played),
		Count:          1,
	}
}

func part2(input string) int {
	ans := 0

	lines := strings.Split(input, "\n")
	cards := make(map[int]*Card, len(lines))
	for _, line := range lines {
		card := NewCard(line)
		cards[card.ID] = card
	}
	for n := range lines {
		cardID := n + 1
		card, ok := cards[cardID]
		if !ok {
			log.Fatalf("Unknown card: %d", cardID)
		}
		for i := cardID + 1; i <= cardID+card.NumMatches; i++ {
			cards[i].Count += card.Count
		}
	}
	for _, card := range cards {
		ans += card.Count
	}
	return ans
}
