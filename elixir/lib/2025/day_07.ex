defmodule AdventOfCode.Y2025.Day07 do
  @moduledoc """
  # Day 7: Laboratories

  Problem Link: https://adventofcode.com/2025/day/7
  """
  use AdventOfCode.Helpers.InputReader, year: 2025, day: 7

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

  You thank the cephalopods for the help and exit the trash compactor,
  finding yourself in the [familiar](/2024/day/6)[halls](/2018/day/4) of a
  North Pole research wing.

  Based on the large sign that says "teleporter hub", they seem to be
  researching *teleportation*; you can't help but try it for yourself and
  step onto the large yellow teleporter pad.

  Suddenly, you find yourself in an unfamiliar room! The room has no
  doors; the only way out is the teleporter. Unfortunately, the teleporter
  seems to be leaking <a href="https://en.wikipedia.org/wiki/Magic_smoke"
  target="_blank">magic smoke</a>.

  Since this is a teleporter lab, there are lots of spare parts, manuals,
  and diagnostic equipment lying around. After connecting one of the
  diagnostic tools, it helpfully displays error code `0H-N0`, which
  apparently means that there's an issue with one of the *tachyon
  manifolds*.

  You quickly locate a diagram of the tachyon manifold (your puzzle
  input). A tachyon beam enters the manifold at the location marked `S`;
  tachyon beams always move *downward*. Tachyon beams pass freely through
  empty space (`.`). However, if a tachyon beam encounters a splitter
  (`^`), the beam is stopped; instead, a new tachyon beam continues from
  the immediate left and from the immediate right of the splitter.

  For example:

    .......S.......
    ...............
    .......^.......
    ...............
    ......^.^......
    ...............
    .....^.^.^.....
    ...............
    ....^.^...^....
    ...............
    ...^.^...^.^...
    ...............
    ..^...^.....^..
    ...............
    .^.^.^.^.^...^.
    ...............

  In this example, the incoming tachyon beam (`|`) extends downward from
  `S` until it reaches the first splitter:

    .......S.......
    .......|.......
    .......^.......
    ...............
    ......^.^......
    ...............
    .....^.^.^.....
    ...............
    ....^.^...^....
    ...............
    ...^.^...^.^...
    ...............
    ..^...^.....^..
    ...............
    .^.^.^.^.^...^.
    ...............

  At that point, the original beam stops, and two new beams are emitted
  from the splitter:

    .......S.......
    .......|.......
    ......|^|......
    ...............
    ......^.^......
    ...............
    .....^.^.^.....
    ...............
    ....^.^...^....
    ...............
    ...^.^...^.^...
    ...............
    ..^...^.....^..
    ...............
    .^.^.^.^.^...^.
    ...............

  Those beams continue downward until they reach more splitters:

    .......S.......
    .......|.......
    ......|^|......
    ......|.|......
    ......^.^......
    ...............
    .....^.^.^.....
    ...............
    ....^.^...^....
    ...............
    ...^.^...^.^...
    ...............
    ..^...^.....^..
    ...............
    .^.^.^.^.^...^.
    ...............

  At this point, the two splitters create a total of only *three* tachyon
  beams, since they are both dumping tachyons into the same place between
  them:

    .......S.......
    .......|.......
    ......|^|......
    ......|.|......
    .....|^|^|.....
    ...............
    .....^.^.^.....
    ...............
    ....^.^...^....
    ...............
    ...^.^...^.^...
    ...............
    ..^...^.....^..
    ...............
    .^.^.^.^.^...^.
    ...............

  This process continues until all of the tachyon beams reach a splitter
  or exit the manifold:

    .......S.......
    .......|.......
    ......|^|......
    ......|.|......
    .....|^|^|.....
    .....|.|.|.....
    ....|^|^|^|....
    ....|.|.|.|....
    ...|^|^|||^|...
    ...|.|.|||.|...
    ..|^|^|||^|^|..
    ..|.|.|||.|.|..
    .|^|||^||.||^|.
    .|.|||.||.||.|.
    |^|^|^|^|^|||^|
    |.|.|.|.|.|||.|

  To repair the teleporter, you first need to understand the
  beam-splitting properties of the tachyon manifold. In this example, a
  tachyon beam is split a total of *`21`* times.

  Analyze your manifold diagram. *How many times will the beam be split?*

  """
  def solve_1(data) do
    {grid, {max_col, max_row}} =
      for {line, row} <- Enum.with_index(data),
          {cell, column} <-
            Enum.with_index(String.graphemes(line)),
          reduce: {%{}, {0, 0}} do
        {grid, {max_col, max_row}} ->
          grid =
            if cell in ~w[S ^] do
              Map.put(grid, {column, row}, cell)
            else
              grid
            end

          {grid, {max(max_col, column), max(max_row, row)}}
      end

    {1, max_row, grid}
    |> Stream.unfold(fn
      {y, max_row, _} when y > max_row ->
        nil

      {y, max_row, grid} ->
        {updated_grid, splits} =
          for x <- 0..max_col, reduce: {grid, 0} do
            {grid, splits} ->
              case {Map.get(grid, {x, y - 1}), Map.get(grid, {x, y})} do
                {"|", "^"} ->
                  {grid
                   |> Map.put({x - 1, y}, "|")
                   |> Map.put({x + 1, y}, "|"), splits + 1}

                {beam, _} when beam in ~w[S |] ->
                  {grid
                   |> Map.put({x, y}, "|"), splits}

                _other ->
                  {grid, splits}
              end
          end

        {splits, {y + 1, max_row, updated_grid}}
    end)
    |> Enum.sum()
  end

  @doc """
  # Part 2

  With your analysis of the manifold complete, you begin fixing the
  teleporter. However, as you open the side of the teleporter to replace
  the broken manifold, you are surprised to discover that it isn't a
  classical tachyon manifold - it's a
  *<span title="Please disregard the wave interference patterns that would arise from the wave-particle duality of individual tachyon particles while repairing the manifold.">quantum</span>
  tachyon manifold*.

  With a quantum tachyon manifold, only a *single tachyon particle* is
  sent through the manifold. A tachyon particle takes *both* the left and
  right path of each splitter encountered.

  Since this is impossible, the manual recommends the many-worlds
  interpretation of quantum tachyon splitting: each time a particle
  reaches a splitter, it's actually *time itself* which splits. In one
  timeline, the particle went left, and in the other timeline, the
  particle went right.

  To fix the manifold, what you really need to know is the *number of
  timelines* active after a single particle completes all of its possible
  journeys through the manifold.

  In the above example, there are many timelines. For instance, there's
  the timeline where the particle always went left:

    .......S.......
    .......|.......
    ......|^.......
    ......|........
    .....|^.^......
    .....|.........
    ....|^.^.^.....
    ....|..........
    ...|^.^...^....
    ...|...........
    ..|^.^...^.^...
    ..|............
    .|^...^.....^..
    .|.............
    |^.^.^.^.^...^.
    |..............

  Or, there's the timeline where the particle alternated going left and
  right at each splitter:

    .......S.......
    .......|.......
    ......|^.......
    ......|........
    ......^|^......
    .......|.......
    .....^|^.^.....
    ......|........
    ....^.^|..^....
    .......|.......
    ...^.^.|.^.^...
    .......|.......
    ..^...^|....^..
    .......|.......
    .^.^.^|^.^...^.
    ......|........

  Or, there's the timeline where the particle ends up at the same point as
  the alternating timeline, but takes a totally different path to get
  there:

    .......S.......
    .......|.......
    ......|^.......
    ......|........
    .....|^.^......
    .....|.........
    ....|^.^.^.....
    ....|..........
    ....^|^...^....
    .....|.........
    ...^.^|..^.^...
    ......|........
    ..^..|^.....^..
    .....|.........
    .^.^.^|^.^...^.
    ......|........

  In this example, in total, the particle ends up on *`40`* different
  timelines.

  Apply the many-worlds interpretation of quantum tachyon splitting to
  your manifold diagram. *In total, how many different timelines would a
  single tachyon particle end up on?*

  """
  def solve_2(data) do
    {grid, {max_col, max_row}} =
      for {line, row} <- Enum.with_index(data),
          {cell, column} <-
            Enum.with_index(String.graphemes(line)),
          reduce: {%{}, {0, 0}} do
        {grid, {max_col, max_row}} ->
          grid =
            if cell in ~w[S ^] do
              Map.put(grid, {column, row}, cell)
            else
              grid
            end

          {grid, {max(max_col, column), max(max_row, row)}}
      end

    dag = :digraph.new()

    beam_pos =
      Enum.find_value(grid, fn
        {{x, y}, "S"} -> {x, y + 1}
        _ -> false
      end)

    {_, root_y} = root = :digraph.add_vertex(dag, beam_pos)

    {MapSet.new([root]), root_y + 1}
    |> Stream.unfold(fn
      {_prev_beams, y} when y > max_row ->
        nil

      {prev_beams, y} ->
        beams =
          for {px, _py} = prev_beam_vertex <- prev_beams, reduce: MapSet.new() do
            acc ->
              case Map.get(grid, {px, y}) do
                "^" ->
                  for {sx, _} = split <- [{px - 1, y}, {px + 1, y}], reduce: acc do
                    acc ->
                      if prev = Enum.find(prev_beams, fn {x, _} -> x == sx end) do
                        MapSet.put(acc, prev)
                      else
                        :digraph.add_vertex(dag, split)
                        :digraph.add_edge(dag, prev_beam_vertex, split)
                        MapSet.put(acc, split)
                      end
                  end

                _other ->
                  MapSet.put(acc, prev_beam_vertex)
              end
          end

        # IO.inspect(Enum.count(beams), label: y)
        {y, {beams, y + 1}}
    end)
    |> Stream.run()

    # print(grid, dag, max_col, max_row)

    # :digraph.info(dag) |> dbg()
    # :digraph.no_edges(dag) |> dbg()
    # :digraph_utils.is_acyclic(dag) |> dbg()
    # :digraph_utils.is_tree(dag) |> dbg()
    # :digraph_utils.is_arborescence(dag) |> dbg()
    # :digraph_utils.postorder(dag) |> dbg()
    # :digraph_utils.preorder(dag) |> dbg()
    # :digraph_utils.topsort(dag) |> dbg()
    # :digraph.vertices(dag) |> Enum.count() |> dbg()

    ways =
      for v <- :digraph_utils.topsort(dag), reduce: %{root => 1} do
        acc ->
          for n <- :digraph.out_neighbours(dag, v), reduce: acc do
            acc ->
              Map.update(acc, n, 1, &(&1 + Map.get(acc, v, 1)))
          end
      end

    for v <- :digraph.vertices(dag), :digraph.out_degree(dag, v) == 0, reduce: 0 do
      acc -> acc + Map.get(ways, v)
    end
  end

  # --- </Solution Functions> ---

  # defp dfs(_grid, {_beam_x, max_row}, max_row, cache, count), do: {cache, count + 1}
  #
  # defp dfs(grid, {beam_x, beam_y}, max_row, cache, count) do
  #   case cache
  #   |> Map.put_new_lazy({beam_x, beam_y}, fn ->
  #     case Map.get(grid, {beam_x, beam_y + 1}) do
  #       "^" ->
  #         {cache, left_count} = dfs(grid, {beam_x - 1, beam_y + 1}, max_row, cache, count)
  #         {cache, right_count} = dfs(grid, {beam_x - 1, beam_y + 1}, max_row, cache, count)
  #
  #         {Map.put(cache, left_count + right_count}
  #         |> Map.put({beam_x})
  #
  #         dfs(grid, {beam_x + 1, beam_y + 1}, max_row, cache, count)
  #
  #       _ ->
  #         dfs(grid, {beam_x, beam_y + 1}, max_row, cache, count)
  #     end
  #   end)
  #   |> Map.get({beam_x, beam_y})
  # end

  defp print(grid, dag, max_col, max_row) do
    grid = Enum.reduce(:digraph.vertices(dag), grid, &Map.put(&2, &1, "|"))

    for y <- 0..max_row do
      for x <- 0..max_col do
        grid
        |> Map.get({x, y}, ".")
        |> IO.write()
      end

      IO.write("\n")
    end
  end
end
