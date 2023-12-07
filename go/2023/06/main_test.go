package main

import (
	"testing"
)

var sample = `Time:      7  15   30
Distance:  9  40  200`

func Test_part1(t *testing.T) {
	tests := []struct {
		name  string
		input string
		want  int
	}{
		{
			name:  "sample",
			input: sample,
			want:  288,
		},
		{
			name:  "actual",
			input: input,
			want:  449820,
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
		// {
		// 	name:  "sample",
		// 	input: sample,
		// 	want:  -1,
		// },
		// {
		// 	name:  "actual",
		// 	input: input,
		// 	want:  -1,
		// },
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := part2(tt.input); got != tt.want {
				t.Errorf("part2() = %v, want %v", got, tt.want)
			}
		})
	}
}
