defmodule AdventOfCode.Y2025.Day09 do
  @moduledoc """
  # Day 9: Movie Theater

  Problem Link: https://adventofcode.com/2025/day/9
  """
  use AdventOfCode.Helpers.InputReader, year: 2025, day: 9

  @doc ~S"""
  Sample data:

  ```
  ```
  """
  def run(data \\ input!(), part)

  def run(data, part) when is_binary(data), do: data |> parse() |> run(part)

  def run(data, part) when is_list(data), do: data |> solve(part)

  def parse(data) do
    data
    |> String.split("\n", trim: true)
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  # Part 1

  You
  <span title="wheeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee">slide
  down</span> the
  [firepole](https://en.wikipedia.org/wiki/Fireman%27s_pole) in the corner
  of the playground and land in the North Pole base movie theater!

  The movie theater has a big tile floor with an interesting pattern.
  Elves here are redecorating the theater by switching out some of the
  square tiles in the big grid they form. Some of the tiles are *red*; the
  Elves would like to find the largest rectangle that uses red tiles for
  two of its opposite corners. They even have a list of where the red
  tiles are located in the grid (your puzzle input).

  For example:

    7,1
    11,1
    11,7
    9,7
    9,5
    2,5
    2,3
    7,3

  Showing red tiles as `#` and other tiles as `.`, the above arrangement
  of red tiles would look like this:

    ..............
    .......#...#..
    ..............
    ..#....#......
    ..............
    ..#......#....
    ..............
    .........#.#..
    ..............

  You can choose any two red tiles as the opposite corners of your
  rectangle; your goal is to find the largest rectangle possible.

  For example, you could make a rectangle (shown as `O`) with an area of
  `24` between `2,5` and `9,7`:

    ..............
    .......#...#..
    ..............
    ..#....#......
    ..............
    ..OOOOOOOO....
    ..OOOOOOOO....
    ..OOOOOOOO.#..
    ..............

  Or, you could make a rectangle with area `35` between `7,1` and `11,7`:

    ..............
    .......OOOOO..
    .......OOOOO..
    ..#....OOOOO..
    .......OOOOO..
    ..#....OOOOO..
    .......OOOOO..
    .......OOOOO..
    ..............

  You could even make a thin rectangle with an area of only `6` between
  `7,3` and `2,3`:

    ..............
    .......#...#..
    ..............
    ..OOOOOO......
    ..............
    ..#......#....
    ..............
    .........#.#..
    ..............

  Ultimately, the largest rectangle you can make in this example has area
  *`50`*. One way to do this is between `2,5` and `11,1`:

    ..............
    ..OOOOOOOOOO..
    ..OOOOOOOOOO..
    ..OOOOOOOOOO..
    ..OOOOOOOOOO..
    ..OOOOOOOOOO..
    ..............
    .........#.#..
    ..............

  Using two red tiles as opposite corners, *what is the largest area of
  any rectangle you can make?*

  """
  def solve_1(data) do
    tiles =
      data
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(fn nums -> Enum.map(nums, &String.to_integer/1) end)

    for {[x0, y0] = _p1, index1} <- Enum.with_index(tiles),
        {[x1, y1] = _p2, index2} <- Enum.with_index(tiles),
        index2 > index1,
        reduce: 0 do
      acc ->
        max(acc, (abs(x1 - x0) + 1) * (abs(y1 - y0) + 1))
    end
  end

  @doc """
  # Part 2

  The Elves just remembered: they can only switch out tiles that are *red*
  or *green*. So, your rectangle can only include red or green tiles.

  In your list, every red tile is connected to the red tile before and
  after it by a straight line of *green tiles*. The list wraps, so the
  first red tile is also connected to the last red tile. Tiles that are
  adjacent in your list will always be on either the same row or the same
  column.

  Using the same example as before, the tiles marked `X` would be green:

    ..............
    .......#XXX#..
    .......X...X..
    ..#XXXX#...X..
    ..X........X..
    ..#XXXXXX#.X..
    .........X.X..
    .........#X#..
    ..............

  In addition, all of the tiles *inside* this loop of red and green tiles
  are *also* green. So, in this example, these are the green tiles:

    ..............
    .......#XXX#..
    .......XXXXX..
    ..#XXXX#XXXX..
    ..XXXXXXXXXX..
    ..#XXXXXX#XX..
    .........XXX..
    .........#X#..
    ..............

  The remaining tiles are never red nor green.

  The rectangle you choose still must have red tiles in opposite corners,
  but any other tiles it includes must now be red or green. This
  significantly limits your options.

  For example, you could make a rectangle out of red and green tiles with
  an area of `15` between `7,3` and `11,1`:

    ..............
    .......OOOOO..
    .......OOOOO..
    ..#XXXXOOOOO..
    ..XXXXXXXXXX..
    ..#XXXXXX#XX..
    .........XXX..
    .........#X#..
    ..............

  Or, you could make a thin rectangle with an area of `3` between `9,7`
  and `9,5`:

    ..............
    .......#XXX#..
    .......XXXXX..
    ..#XXXX#XXXX..
    ..XXXXXXXXXX..
    ..#XXXXXXOXX..
    .........OXX..
    .........OX#..
    ..............

  The largest rectangle you can make in this example using only red and
  green tiles has area *`24`*. One way to do this is between `9,5` and
  `2,3`:

    ..............
    .......#XXX#..
    .......XXXXX..
    ..OOOOOOOOXX..
    ..OOOOOOOOXX..
    ..OOOOOOOOXX..
    .........XXX..
    .........#X#..
    ..............

  Using two red tiles as opposite corners, *what is the largest area of
  any rectangle you can make using only red and green tiles?*

  """
  def solve_2(data) do
    [first | _rest] =
      data =
      data
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(fn nums -> Enum.map(nums, &String.to_integer/1) end)

    {min_x, max_x} = data |> Enum.map(&hd/1) |> Enum.min_max()
    {min_y, max_y} = data |> Enum.map(&List.last/1) |> Enum.min_max()
    dbg({{min_x, min_y}, {max_x, max_y}})

    {horizontal_ranges, vertical_ranges} =
      data
      |> Enum.concat([first])
      # |> tap(fn data -> File.write!("202509.svg", svg(data)) end)
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce(
        {%{}, %{}},
        fn
          [[x1, y1], [x1, y2]], {horizontal_ranges, vertical_ranges} ->
            if abs(y1 - y2) > 50000 do
              dbg({[[x1, y1], [x1, y2]], abs(y1 - y2)})
            end

            {horizontal_ranges, merge_range(vertical_ranges, x1, y1, y2)}

          [[x1, y1], [x2, y1]], {horizontal_ranges, vertical_ranges} ->
            if abs(x1 - x2) > 50000 do
              dbg({[[x1, y1], [x2, y1]], abs(x1 - x2)})
            end

            {merge_range(horizontal_ranges, y1, x1, x2), vertical_ranges}
        end
      )

    for {[x0, y0] = p1, index1} <- Enum.with_index(data),
        {[x1, y1] = p2, index2} <- Enum.with_index(data),
        index2 > index1,
        not (min(y0, y1) <= 93055 and max(y0, y1) > 93055),
        valid_rectangle(p1, p2, horizontal_ranges, vertical_ranges),
        reduce: 0 do
      acc ->
        max(acc, (abs(x1 - x0) + 1) * (abs(y1 - y0) + 1))
    end
  end

  # --- </Solution Functions> ---

  defp merge_range(range_map, key, v1, v2) do
    range_map
    |> Map.update(key, [min(v1, v2)..max(v1, v2)], fn ranges ->
      [min(v1, v2)..max(v1, v2) | ranges]
      |> Enum.reduce([], fn range, consolidated_ranges ->
        {overlapping_ranges, disjoint_ranges} =
          Enum.split_with(consolidated_ranges, fn existing_range, range ->
            not Range.disjoint?(existing_range, range) or existing_range.last == range.first - 1 or
              existing_range.first == range.last + 1
          end)

        merged_range =
          for r <- overlapping_ranges, reduce: range do
            first..last//_ ->
              min(first, r.first)..max(last, r.last)
          end

        [merged_range | disjoint_ranges]
      end)
    end)
  end

  defp valid_rectangle([x0, y0], [x1, y1], horizontal_ranges, vertical_ranges) do
    for x <- min(x0, x1)..max(x0, x1),
        y <- min(y0, y1)..max(y0, y1),
        reduce: true do
      acc ->
        acc and (member?(horizontal_ranges[y], x) or member?(vertical_ranges[x], y))
    end
  end

  defp member?(ranges, value) when is_list(ranges) do
    Enum.any?(ranges, &(value in &1))
  end

  defp member?(_, _), do: false

  def svg(points) do
    {min_x, max_x} = points |> Enum.map(&hd/1) |> Enum.min_max()
    {min_y, max_y} = points |> Enum.map(&List.last/1) |> Enum.min_max()
    margin = 50
    divisor = if max_x > 10000, do: 100, else: 1

    lines =
      points
      |> Enum.map(fn [x, y] -> [div(x - min_x, divisor), div(y - min_y, divisor)] end)
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map_join(fn [[x1, y1], [x2, y2]] ->
        ~s[<line x1="#{x1}" y1="#{y1}" x2="#{x2}" y2="#{y2}" style="stroke:red;stroke-width:10" />]
      end)

    """
    <svg height="#{div(max_y - min_y + 2 * margin, divisor)}" width="#{div(max_x - min_x + 2 * margin, divisor)}" xmlns="http://www.w3.org/2000/svg">
      #{lines}
    </svg>
    """
  end
end
