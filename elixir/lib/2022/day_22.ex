defmodule AdventOfCode.Y2022.Day22 do
  @moduledoc """
  # Day 22: Monkey Map

  Problem Link: https://adventofcode.com/2022/day/22
  """
  use AdventOfCode.Helpers.InputReader, year: 2022, day: 22

  @doc ~S"""
  Sample data:

  ```
  ```
  """
  def run(data \\ input!(), part)

  def run(data, part) when is_binary(data), do: data |> parse() |> run(part)

  def run(data, part), do: data |> solve(part)

  defmodule Parser do
    import NimbleParsec

    defparsec(
      :directions,
      choice([integer(min: 1), string("L"), string("R")])
      |> repeat()
    )
  end

  @cell ?.
  @wall ?#

  @right ">"
  @down "v"
  @left "<"
  @up "^"

  defstruct grid: %{}, x_dim: 1..1, y_dim: 1..1, position: {1, 1}, heading: @right, directions: []

  def parse(data) do
    [grove, directions] =
      data
      |> String.split("\n\n", trim: false)

    [first_row | _] =
      grove =
      grove
      |> String.split("\n")
      |> Enum.map(&to_charlist/1)

    max_x = length(first_row)
    max_y = length(grove)

    start_x =
      first_row
      |> Enum.with_index(1)
      |> Enum.find_value(fn {cell, x} -> if cell == ?., do: x end)

    grid =
      for {row, y} <- grove |> Enum.with_index(1),
          {cell, x} <- Enum.with_index(row, 1),
          [cell] != ' ',
          into: %{} do
        {{x, y}, cell}
      end

    {:ok, directions, "", _, _, _} = Parser.directions(String.trim(directions))

    %__MODULE__{
      grid: grid,
      x_dim: 1..max_x,
      y_dim: 1..max_y,
      position: {start_x, 1},
      directions: directions,
      heading: @right
    }
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  # Part 1

  The monkeys take you on a surprisingly easy trail through the jungle.
  They're even going in roughly the right direction according to your
  handheld device's Grove Positioning System.

  As you walk, the monkeys explain that the grove is protected by a *force
  field*. To pass through the force field, you have to enter a password;
  doing so involves tracing a specific *path* on a strangely-shaped board.

  At least, you're pretty sure that's what you have to do; the elephants
  aren't exactly fluent in monkey.

  The monkeys give you notes that they took when they last saw the
  password entered (your puzzle input).

  For example:

              ...#
              .#..
              #...
              ....
      ...#.......#
      ........#...
      ..#....#....
      ..........#.
              ...#....
              .....#..
              .#......
              ......#.

      10R5L5R10L4R5L5

  The first half of the monkeys' notes is a *map of the board*. It is
  comprised of a set of *open tiles* (on which you can move, drawn `.`)
  and *solid walls* (tiles which you cannot enter, drawn `#`).

  The second half is a description of *the path you must follow*. It
  consists of alternating numbers and letters:

  - A *number* indicates the *number of tiles to move* in the direction
    you are facing. If you run into a wall, you stop moving forward and
    continue with the next instruction.
  - A *letter* indicates whether to turn 90 degrees *clockwise* (`R`) or
    *<span title="Or &quot;anticlockwise&quot;, if you're anti-counterclockwise.">counterclockwise</span>*
    (`L`). Turning happens in-place; it does not change your current tile.

  So, a path like `10R5` means "go forward 10 tiles, then turn clockwise
  90 degrees, then go forward 5 tiles".

  You begin the path in the leftmost open tile of the top row of tiles.
  Initially, you are facing *to the right* (from the perspective of how
  the map is drawn).

  If a movement instruction would take you off of the map, you *wrap
  around* to the other side of the board. In other words, if your next
  tile is off of the board, you should instead look in the direction
  opposite of your current facing as far as you can until you find the
  opposite edge of the board, then reappear there.

  For example, if you are at `A` and facing to the right, the tile in
  front of you is marked `B`; if you are at `C` and facing down, the tile
  in front of you is marked `D`:

              ...#
              .#..
              #...
              ....
      ...#.D.....#
      ........#...
      B.#....#...A
      .....C....#.
              ...#....
              .....#..
              .#......
              ......#.

  It is possible for the next tile (after wrapping around) to be a *wall*;
  this still counts as there being a wall in front of you, and so movement
  stops before you actually wrap to the other side of the board.

  By drawing the *last facing you had* with an arrow on each tile you
  visit, the full path taken by the above example looks like this:

              >>v#    
              .#v.    
              #.v.    
              ..v.    
      ...#...v..v#    
      >>>v...>#.>>    
      ..#v...#....    
      ...>>>>v..#.    
              ...#....
              .....#..
              .#......
              ......#.

  To finish providing the password to this strange input device, you need
  to determine numbers for your final *row*, *column*, and *facing* as
  your final position appears from the perspective of the original map.
  Rows start from `1` at the top and count downward; columns start from
  `1` at the left and count rightward. (In the above example, row 1,
  column 1 refers to the empty space with no tile on it in the top-left
  corner.) Facing is `0` for right (`>`), `1` for down (`v`), `2` for left
  (`<`), and `3` for up (`^`). The *final password* is the sum of 1000
  times the row, 4 times the column, and the facing.

  In the above example, the final row is `6`, the final column is `8`, and
  the final facing is `0`. So, the final password is 1000 \* 6 + 4 \* 8 +
  0: *`6032`*.

  Follow the path given in the monkeys' notes. *What is the final
  password?*

  """
  def solve_1(%__MODULE__{} = grove) do
    %__MODULE__{position: {x, y}, heading: heading} = walk(grove)

    y * 1000 + x * 4 + heading_score(heading)
  end

  defp walk(%__MODULE__{directions: []} = grove), do: grove

  defp walk(%__MODULE__{directions: [step | directions], heading: heading} = grove)
       when step in ["R", "L"] do
    %{grove | directions: directions, heading: rotate(heading, step)}
    |> walk()
  end

  defp walk(%__MODULE__{directions: [step | directions]} = grove)
       when is_integer(step) do
    grove = %{grove | directions: directions}

    Enum.reduce_while(1..step, grove, fn _, %__MODULE__{} = grove ->
      next_position = next_position(grove.grid, grove.position, grove.heading)

      if grove.grid[next_position] == @wall do
        {:halt, grove}
      else
        {:cont, %{grove | position: next_position}}
      end
    end)
    |> walk()
  end

  defp next_position(grid, {x0, y0} = p0, @right) do
    {row_start, row_end} = start_end(grid, p0, @right)

    if x0 == row_end, do: {row_start, y0}, else: {x0 + 1, y0}
  end

  defp next_position(grid, {x0, y0} = p0, @left) do
    {row_start, row_end} = start_end(grid, p0, @left)

    if(x0 == row_start,
      do: {row_end, y0},
      else: {x0 - 1, y0}
    )
  end

  defp next_position(grid, {x0, y0} = p0, @up) do
    {col_start, col_end} = start_end(grid, p0, @up)

    if y0 == col_start, do: {x0, col_end}, else: {x0, y0 - 1}
  end

  defp next_position(grid, {x0, y0} = p0, @down) do
    {col_start, col_end} = start_end(grid, p0, @down)

    if y0 == col_end, do: {x0, col_start}, else: {x0, y0 + 1}
  end

  defp start_end(grid, {_x0, y0}, heading) when heading in [@right, @left] do
    for {x, ^y0} <- Map.keys(grid) do
      x
    end
    |> Enum.min_max()
  end

  defp start_end(grid, {x0, _y0}, heading) when heading in [@up, @down] do
    for {^x0, y} <- Map.keys(grid) do
      y
    end
    |> Enum.min_max()
  rescue
    e ->
      IO.inspect({x0, heading})
      reraise e, __STACKTRACE__
  end

  defp heading_score(@right), do: 0
  defp heading_score(@down), do: 1
  defp heading_score(@left), do: 2
  defp heading_score(@up), do: 3

  defp rotate(@right, "R"), do: @down
  defp rotate(@down, "R"), do: @left
  defp rotate(@left, "R"), do: @up
  defp rotate(@up, "R"), do: @right

  defp rotate(heading, "L") do
    heading
    |> rotate("R")
    |> rotate("R")
    |> rotate("R")
  end

  @doc """
  # Part 2

  As you reach the force field, you think you hear some Elves in the
  distance. Perhaps they've already arrived?

  You approach the strange *input device*, but it isn't quite what the
  monkeys drew in their notes. Instead, you are met with a large *cube*;
  each of its six faces is a square of 50x50 tiles.

  To be fair, the monkeys' map *does* have six 50x50 regions on it. If you
  were to *carefully fold the map*, you should be able to shape it into a
  cube!

  In the example above, the six (smaller, 4x4) faces of the cube are:

              1111
              1111
              1111
              1111
      222233334444
      222233334444
      222233334444
      222233334444
              55556666
              55556666
              55556666
              55556666

  You still start in the same position and with the same facing as before,
  but the *wrapping* rules are different. Now, if you would walk off the
  board, you instead *proceed around the cube*. From the perspective of
  the map, this can look a little strange. In the above example, if you
  are at A and move to the right, you would arrive at B facing down; if
  you are at C and move down, you would arrive at D facing up:

              ...#
              .#..
              #...
              ....
      ...#.......#
      ........#..A
      ..#....#....
      .D........#.
              ...#..B.
              .....#..
              .#......
              ..C...#.

  Walls still block your path, even if they are on a different face of the
  cube. If you are at E facing up, your movement is blocked by the wall
  marked by the arrow:

              ...#
              .#..
           -->#...
              ....
      ...#..E....#
      ........#...
      ..#....#....
      ..........#.
              ...#....
              .....#..
              .#......
              ......#.

  Using the same method of drawing the *last facing you had* with an arrow
  on each tile you visit, the full path taken by the above example now
  looks like this:

              >>v#    
              .#v.    
              #.v.    
              ..v.    
      ...#..^...v#    
      .>>>>>^.#.>>    
      .^#....#....    
      .^........#.    
              ...#..v.
              .....#v.
              .#v<<<<.
              ..v...#.

  The final password is still calculated from your final position and
  facing from the perspective of the map. In this example, the final row
  is `5`, the final column is `7`, and the final facing is `3`, so the
  final password is 1000 \* 5 + 4 \* 7 + 3 = *`5031`*.

  Fold the map into a cube, *then* follow the path given in the monkeys'
  notes. *What is the final password?*
  """
  def solve_2(data) do
    {2, :not_implemented, data}
  end

  # --- </Solution Functions> ---
end
