package main

import (
	"testing"
)

var sample = `#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#`

func Test_part1(t *testing.T) {
	tests := []struct {
		name  string
		input string
		want  int
	}{
		{
			name:  "sample",
			input: sample,
			want:  405,
		},
		{
			name: "actual 0",
			input: `.####.#...##.#.
...###.##.#.#..
...###.##.#.#..
.####.#...#..#.
..##......#..#.
#.#...#.##...##
.#.#.#..##..##.
#..##...#####.#
.#.#.#.#..##.#.
.....###.#.#..#
.....###.#.#..#`,
			want: 1000,
		},
		{
			name: "actual 1",
			input: `.#.###.....
#..#.##...#
.#.....#.#.
.#.....#.#.
#..#.##...#
.#.###.....
##.#..##.##
#....##..#.
.##.##.#.##
...#..###.#
...#..###.#
.##.##.#.##
#....##..#.
####..##.##
.#.###.....
#..#.##...#
.#.....#.#.`,
			want: 300,
		},
		{
			name:  "actual",
			input: input,
			want:  30535,
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
		name  string
		input string
		want  int
	}{
		{
			name:  "sample",
			input: sample,
			want:  400,
		},
		{
			name:  "actual",
			input: input,
			want:  30844,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := part2(tt.input); got != tt.want {
				t.Errorf("part2() = %v, want %v", got, tt.want)
			}
		})
	}
}
