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

func rowsCols(field string) (rows []string, cols []string) {
	rows = strings.Split(field, "\n")

	for i := 0; i < len(rows[0]); i++ {
		col := make([]byte, len(rows))
		for j := 0; j < len(rows); j++ {
			col = append(col, rows[j][i])
		}
		cols = append(cols, string(col))
	}

	return
}

func reflectsAround(rows []string) (idx int) {
	n := len(rows)
	for i := 1; i < n; i++ {
		isReflected := true
		x := min(i, n-i)
		for j := 0; isReflected && j < x; j++ {
			// fmt.Println(i, j, n, x, i-(j+1), rows[i-(j+1)], i+j, rows[i+j])
			isReflected = isReflected && (rows[i-(j+1)] == rows[i+j])
		}
		if isReflected {
			return i
		}
	}
	return
}

func fieldValue(rows []string, cols []string) (ans int) {
	// fmt.Println("checking vertical")
	if ans = reflectsAround(cols); ans > 0 {
		// fmt.Println("cols", ans)
		return
	}

	// fmt.Println("checking horizontal")
	ans = reflectsAround(rows)
	if ans > 0 {
		// fmt.Println("rows", ans)
	}
	ans *= 100
	return
}

func part1(input string) (ans int) {
	fields := strings.Split(input, "\n\n")

	for i, f := range fields {
		// fmt.Println(f)
		rows, cols := rowsCols(f)
		fv := fieldValue(rows, cols)
		if fv == 0 {
			log.Fatalf("\n%d: No reflection found for %dx%d field\n%s\n", i, len(cols), len(rows), f)
		}
		ans += fv
	}

	return
}

func part2(input string) (ans int) {
	lines := strings.Split(input, "\n")

	ans = len(lines)
	return
}
