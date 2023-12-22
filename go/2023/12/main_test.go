package main

import (
	"testing"
)

var sample = `???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1`

func Test_part1(t *testing.T) {
	tests := []struct {
		name  string
		input string
		want  int
	}{
		{
			name:  "sample",
			input: sample,
			want:  21,
		},
		{
			name:  "sample",
			input: "???.### 1,1,3",
			want:  1,
		},
		{
			name:  "sample",
			input: ".??..??...?##. 1,1,3",
			want:  4,
		},
		{
			name:  "actual",
			input: input,
			want:  7622,
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
