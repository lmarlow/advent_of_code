defmodule AdventOfCode.Y2022.Day18 do
  @moduledoc """
  # Day 18: Boiling Boulders

  Problem Link: https://adventofcode.com/2022/day/18
  """
  use AdventOfCode.Helpers.InputReader, year: 2022, day: 18

  @doc ~S"""
  Sample data:

  ```
  ```
  """
  def run(data \\ input!(), part)

  def run(data, part) when is_binary(data), do: data |> parse() |> run(part)

  def run(data, part) when is_list(data), do: data |> solve(part)

  import NimbleParsec

  defparsecp(
    :xyz,
    integer(min: 1)
    |> ignore(string(","))
    |> integer(min: 1)
    |> ignore(string(","))
    |> integer(min: 1)
  )

  def parse(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&xyz/1)
    |> Enum.map(&elem(&1, 1))
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  # Part 1

  You and the elephants finally reach fresh air. You've emerged near the
  base of a large volcano that seems to be actively erupting! Fortunately,
  the lava seems to be flowing away from you and toward the ocean.

  Bits of lava are still being ejected toward you, so you're sheltering in
  the cavern exit a little longer. Outside the cave, you can see the lava
  landing in a pond and hear it loudly hissing as it solidifies.

  Depending on the specific compounds in the lava and speed at which it
  cools, it might be forming
  <a href="https://en.wikipedia.org/wiki/Obsidian"
  target="_blank">obsidian</a>! The cooling rate should be based on the
  surface area of the lava droplets, so you take a quick scan of a droplet
  as it flies past you (your puzzle input).

  Because of how quickly the lava is moving, the scan isn't very good; its
  resolution is quite low and, as a result, it approximates the shape of
  the lava droplet with *1x1x1 <span
  title="Unfortunately, you forgot your flint and steel in another dimension.">cubes</span>
  on a 3D grid*, each given as its `x,y,z` position.

  To approximate the surface area, count the number of sides of each cube
  that are not immediately connected to another cube. So, if your scan
  were only two adjacent cubes like `1,1,1` and `2,1,1`, each cube would
  have a single side covered and five sides exposed, a total surface area
  of *`10`* sides.

  Here's a larger example:

      2,2,2
      1,2,2
      3,2,2
      2,1,2
      2,3,2
      2,2,1
      2,2,3
      2,2,4
      2,2,6
      1,2,5
      3,2,5
      2,1,5
      2,3,5

  In the above example, after counting up all the sides that aren't
  connected to another cube, the total surface area is *`64`*.

  *What is the surface area of your scanned lava droplet?*

  """
  def solve_1(data) do
    net = MapSet.new(data)

    for [x, y, z] <- data,
        dx <- -1..1,
        dy <- -1..1,
        dz <- -1..1,
        Enum.count([dx, dy, dz], &(&1 == 0)) == 2,
        neighbor = [x + dx, y + dy, z + dz],
        neighbor not in net,
        reduce: 0 do
      acc -> acc + 1
    end
  end

  @doc """
  # Part 2
  """
  def solve_2(data) do
    cubes = MapSet.new(data)
    net = :digraph.new()

    neighbors = [[-1, 0, 0], [0, -1, 0], [0, 0, -1], [0, 0, 1], [0, 1, 0], [1, 0, 0]]

    {bounding_neighbors, point_to_vertex} =
      for [x, y, z] = cube <- cubes,
          [dx, dy, dz] <- neighbors,
          neighbor = [x + dx, y + dy, z + dz],
          neighbor not in cubes,
          reduce: {MapSet.new(), %{}} do
        {bounding_neighbors, point_to_vertex} ->
          point_to_vertex =
            point_to_vertex
            |> Map.put_new_lazy(cube, fn -> :digraph.add_vertex(net, cube, cube) end)
            |> Map.put_new_lazy(neighbor, fn -> :digraph.add_vertex(net, neighbor, neighbor) end)

          {MapSet.put(bounding_neighbors, neighbor), point_to_vertex}
      end

    {xmin, xmax} =
      Enum.min_max(Enum.map(bounding_neighbors, fn [x, _, _] -> x end))
      |> IO.inspect(label: :xbounds)

    {ymin, ymax} =
      Enum.min_max(Enum.map(bounding_neighbors, fn [_, y, _] -> y end))
      |> IO.inspect(label: :ybounds)

    {zmin, zmax} =
      Enum.min_max(Enum.map(bounding_neighbors, fn [_, _, z] -> z end))
      |> IO.inspect(label: :zbounds)

    point_to_vertex =
      for x <- xmin..xmax,
          y <- ymin..ymax,
          z <- zmin..zmax,
          point = [x, y, z],
          [dx, dy, dz] <- neighbors,
          neighbor = [x + dx, y + dy, z + dz],
          neighbor not in cubes,
          reduce: point_to_vertex do
        point_to_vertex ->
          point_to_vertex =
            point_to_vertex
            |> Map.put_new_lazy(point, fn -> :digraph.add_vertex(net, point, point) end)
            |> Map.put_new_lazy(neighbor, fn -> :digraph.add_vertex(net, neighbor, neighbor) end)

          point_vertex = Map.get(point_to_vertex, point)
          neighbor_vertex = Map.get(point_to_vertex, neighbor)

          :digraph.add_edge(net, point_vertex, neighbor_vertex)
          point_to_vertex
      end

    outside_point = Enum.min_by(bounding_neighbors, &distance(&1, [xmin, ymin, zmin]))
    outside_vertex = Map.get(point_to_vertex, outside_point)

    for cube <- cubes,
        cube_vertex = Map.get(point_to_vertex, cube),
        reduce: 0 do
      acc ->
        acc +
          Enum.count(:digraph.out_neighbours(net, cube_vertex), fn neighbor_vertex ->
            case :digraph.get_short_path(net, neighbor_vertex, outside_vertex) do
              false -> false
              _ -> true
            end
          end)
    end
  end

  # --- </Solution Functions> ---

  def distance([x0, y0, z0], [x1, y1, z1]) do
    abs(x0 - x1) + abs(y0 - y1) + abs(z0 - z1)
  end
end
