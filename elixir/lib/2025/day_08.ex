defmodule AdventOfCode.Y2025.Day08 do
  @moduledoc """
  # Day 8: Playground

  Problem Link: https://adventofcode.com/2025/day/8
  """
  use AdventOfCode.Helpers.InputReader, year: 2025, day: 8

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

  Equipped with a new understanding of teleporter maintenance, you
  confidently step onto the repaired teleporter pad.

  You rematerialize on an unfamiliar teleporter pad and find yourself in a
  vast underground space which contains a giant playground!

  Across the playground, a group of Elves are working on setting up an
  ambitious Christmas decoration project. Through careful rigging, they
  have suspended a large number of small electrical
  <a href="https://en.wikipedia.org/wiki/Junction_box"
  target="_blank">junction boxes</a>.

  Their plan is to connect the junction boxes with long strings of lights.
  Most of the junction boxes don't provide electricity; however, when two
  junction boxes are connected by a string of lights, electricity can pass
  between those two junction boxes.

  The Elves are trying to figure out *which junction boxes to connect* so
  that electricity can reach *every* junction box. They even have a list
  of all of the junction boxes' positions in 3D space (your puzzle input).

  For example:

    162,817,812
    57,618,57
    906,360,560
    592,479,940
    352,342,300
    466,668,158
    542,29,236
    431,825,988
    739,650,466
    52,470,668
    216,146,977
    819,987,18
    117,168,530
    805,96,715
    346,949,466
    970,615,88
    941,993,340
    862,61,35
    984,92,344
    425,690,689

  This list describes the position of 20 junction boxes, one per line.
  Each position is given as `X,Y,Z` coordinates. So, the first junction
  box in the list is at `X=162`, `Y=817`, `Z=812`.

  To save on string lights, the Elves would like to focus on connecting
  pairs of junction boxes that are *as close together as possible*
  according to <a href="https://en.wikipedia.org/wiki/Euclidean_distance"
  target="_blank">straight-line distance</a>. In this example, the two
  junction boxes which are closest together are `162,817,812` and
  `425,690,689`.

  By connecting these two junction boxes together, because electricity can
  flow between them, they become part of the same *circuit*. After
  connecting them, there is a single circuit which contains two junction
  boxes, and the remaining 18 junction boxes remain in their own
  individual circuits.

  Now, the two junction boxes which are closest together but aren't
  already directly connected are `162,817,812` and `431,825,988`. After
  connecting them, since `162,817,812` is already connected to another
  junction box, there is now a single circuit which contains *three*
  junction boxes and an additional 17 circuits which contain one junction
  box each.

  The next two junction boxes to connect are `906,360,560` and
  `805,96,715`. After connecting them, there is a circuit containing 3
  junction boxes, a circuit containing 2 junction boxes, and 15 circuits
  which contain one junction box each.

  The next two junction boxes are `431,825,988` and `425,690,689`. Because
  these two junction boxes were *already in the same circuit*, nothing
  happens!

  This process continues for a while, and the Elves are concerned that
  they don't have enough extension cables for all these circuits. They
  would like to know how big the circuits will be.

  After making the ten shortest connections, there are 11 circuits: one
  circuit which contains *5* junction boxes, one circuit which contains
  *4* junction boxes, two circuits which contain *2* junction boxes each,
  and seven circuits which each contain a single junction box. Multiplying
  together the sizes of the three largest circuits (5, 4, and one of the
  circuits of size 2) produces *`40`*.

  Your list contains many junction boxes; connect together the *1000*
  pairs of junction boxes which are closest together. Afterward, *what do
  you get if you multiply together the sizes of the three largest
  circuits?*

  """
  def solve_1(data) do
    junction_boxes =
      data
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(fn xyz -> Enum.map(xyz, &String.to_integer/1) end)

    all_combos_with_distances =
      for {box1, index1} <- Enum.with_index(junction_boxes),
          {box2, index2} <- Enum.with_index(junction_boxes),
          index2 > index1 do
        [box1, box2] = Enum.sort([box1, box2])
        {box1, box2, distance_squared(box1, box2)}
      end
      |> Enum.sort_by(fn {_, _, distance} -> distance end)
      |> Enum.take(Enum.count(data))

    circuits = Enum.map(junction_boxes, &MapSet.new([&1]))

    all_combos_with_distances
    |> Enum.reduce(circuits, fn {box1, box2, _distance} = _info, circuits ->
      circuits
      |> Enum.split_with(fn circuit -> box1 in circuit or box2 in circuit end)
      |> case do
        {[circuit1, circuit2], rest} ->
          [MapSet.union(circuit1, circuit2) | rest]

        {[circuit1], rest} ->
          [circuit1 | rest]
      end
    end)
    |> Enum.map(&Enum.count/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  @doc """
  # Part 2

  PROBLEM_TEXT_PART2
  """
  def solve_2(data) do
    {:error, data}
  end

  # --- </Solution Functions> ---

  defp distance_squared([x0, y0, z0], [x1, y1, z1]) do
    Integer.pow(x1 - x0, 2) + Integer.pow(y1 - y0, 2) + Integer.pow(z1 - z0, 2)
  end
end
