package main

import (
	"testing"
)

// ...#......
// .......#..
// #.........
// ..........
// ......#...
// .#........
// .........#
// ..........
// .......#..
// #...#.....
var sample = `...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....`

func Test_part1(t *testing.T) {
	tests := []struct {
		name  string
		input string
		want  int
	}{
		{
			name:  "sample",
			input: sample,
			want:  374,
		},
		{
			name:  "actual",
			input: input,
			want:  10289334,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := part1(tt.input); got != tt.want {
				t.Errorf("part1() = %v, want %v", got, tt.want)
			}
		})
	}
}

func Test_part2(t *testing.T) {
	tests := []struct {
		name         string
		input        string
		growthFactor int
		want         int
	}{
		{
			name:         "sample",
			input:        sample,
			growthFactor: 10,
			want:         1030,
		},
		{
			name:         "sample",
			input:        sample,
			growthFactor: 100,
			want:         8410,
		},
		{
			name:         "actual",
			input:        input,
			growthFactor: 1000000,
			want:         649862989626,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := part2(tt.input, tt.growthFactor); got != tt.want {
				t.Errorf("part2() = %v, want %v", got, tt.want)
			}
		})
	}
}
