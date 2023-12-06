package main

import (
	_ "embed"
	"flag"
	"fmt"
	"log"
	"math"
	"slices"
	"strconv"
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

type resourceMap struct {
	src  int
	dst  int
	size int
}

func (r *resourceMap) destination(src int) (dst int, ok bool) {
	ok = src >= r.src && src < r.src+r.size
	if ok {
		dst = r.dst + src - r.src
	}
	return
}

func newResourceMap(src, dst, size int) *resourceMap {
	return &resourceMap{src, dst, size}
}

type resourceMapper struct {
	name         string
	resourceMaps []resourceMap
}

func newResourceMapper(name string) *resourceMapper {
	return &resourceMapper{name: name}
}

func (m *resourceMapper) addMap(src, dst, size int) {
	m.resourceMaps = append(m.resourceMaps, *newResourceMap(src, dst, size))
}

func (m *resourceMapper) destination(src int) int {
	for _, r := range m.resourceMaps {
		if dst, ok := r.destination(src); ok {
			return dst
		}
	}
	return src
}

func destination(src int, resourceMappers []*resourceMapper) int {
	dst := src
	for _, m := range resourceMappers {
		dst = m.destination(dst)
	}
	return dst
}

func parseResourceMappers(lines []string) (resourceMappers []*resourceMapper) {
	var currentMapper *resourceMapper
	var dst, src, size int
	for _, line := range lines[1:] {
		if line == "" {
			continue
		} else if name, found := strings.CutSuffix(line, " map:"); found {
			currentMapper = newResourceMapper(name)
			resourceMappers = append(resourceMappers, currentMapper)
		} else if n, _ := fmt.Sscanf(line, "%d %d %d", &dst, &src, &size); n == 3 {
			currentMapper.addMap(src, dst, size)
		}
	}
	return
}

func part1(input string) int {
	ans := 0

	lines := strings.Split(input, "\n")
	_, strSeeds, _ := strings.Cut(lines[0], ":")
	seeds := strings2Ints(strings.Fields(strSeeds))

	resourceMappers := parseResourceMappers(lines[1:])

	var locations []int
	for _, seed := range seeds {
		locations = append(locations, destination(seed, resourceMappers))
	}

	ans = slices.Min(locations)
	return ans
}

func strings2Ints(intStrings []string) (ints []int) {
	for _, s := range intStrings {
		i, err := strconv.Atoi(s)
		if err != nil {
			log.Fatal(err)
		}
		ints = append(ints, i)
	}
	return ints
}

func part2(input string) int {
	ans := 0

	lines := strings.Split(input, "\n")
	_, strSeeds, _ := strings.Cut(lines[0], ":")
	seedRanges := strings2Ints(strings.Fields(strSeeds))

	resourceMappers := parseResourceMappers(lines[1:])

	ans = math.MaxInt
	for i := 0; i < len(seedRanges); i = i + 2 {
		s := seedRanges[i]
		seedMax := s + seedRanges[i+1]
		for ; s < seedMax; s++ {
			loc := destination(s, resourceMappers)
			ans = min(loc, ans)
		}
	}

	return ans
}
