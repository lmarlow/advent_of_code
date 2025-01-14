defmodule AdventOfCode.Y2022.Day16 do
  @moduledoc """
  # Day 16: Proboscidea Volcanium

  Problem Link: https://adventofcode.com/2022/day/16
  """
  use AdventOfCode.Helpers.InputReader, year: 2022, day: 16

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
      :line,
      eventually(ascii_string(Enum.to_list(?A..?Z), 2))
      |> eventually(integer(min: 1))
      |> eventually(
        ascii_string(Enum.to_list(?A..?Z), 2)
        |> optional(repeat(ignore(string(", ")) |> concat(ascii_string(Enum.to_list(?A..?Z), 2))))
      )
    )
  end

  defstruct valve: nil, flow_rate: 0, connections: []

  @doc """
      Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
  """
  def parse(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&Parser.line/1)
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(fn [valve, flow_rate | connections] ->
      struct(__MODULE__,
        valve: String.to_atom(valve),
        flow_rate: flow_rate,
        connections: Enum.map(connections, &String.to_atom/1)
      )
    end)
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  # Part 1

  The sensors have led you to the origin of the distress signal: yet
  another handheld device, just like the one the Elves gave you. However,
  you don't see any Elves around; instead, the device is surrounded by
  elephants! They must have gotten lost in these tunnels, and one of the
  elephants apparently figured out how to turn on the distress signal.

  The ground rumbles again, much stronger this time. What kind of cave is
  this, exactly? You scan the cave with your handheld device; it reports
  mostly igneous rock, some ash, pockets of pressurized gas, magma... this
  isn't just a cave, it's a volcano!

  You need to get the elephants out of here, quickly. Your device
  estimates that you have *30 minutes* before the volcano erupts, so you
  don't have time to go back out the way you came in.

  You scan the cave for other options and discover a network of pipes and
  pressure-release *valves*. You aren't sure how such a system got into a
  volcano, but you don't have time to complain; your device produces a
  report (your puzzle input) of each valve's *flow rate* if it were opened
  (in pressure per minute) and the tunnels you could use to move between
  the valves.

  There's even a valve in the room you and the elephants are currently
  standing in labeled `AA`. You estimate it will take you one minute to
  open a single valve and one minute to follow any tunnel from one valve
  to another. What is the most pressure you could release?

  For example, suppose you had the following scan output:

      Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
      Valve BB has flow rate=13; tunnels lead to valves CC, AA
      Valve CC has flow rate=2; tunnels lead to valves DD, BB
      Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
      Valve EE has flow rate=3; tunnels lead to valves FF, DD
      Valve FF has flow rate=0; tunnels lead to valves EE, GG
      Valve GG has flow rate=0; tunnels lead to valves FF, HH
      Valve HH has flow rate=22; tunnel leads to valve GG
      Valve II has flow rate=0; tunnels lead to valves AA, JJ
      Valve JJ has flow rate=21; tunnel leads to valve II

  All of the valves begin *closed*. You start at valve `AA`, but it must
  be damaged or <span
  title="Wait, sir! The valve, sir! it appears to be... jammed!">jammed</span>
  or something: its flow rate is `0`, so there's no point in opening it.
  However, you could spend one minute moving to valve `BB` and another
  minute opening it; doing so would release pressure during the remaining
  *28 minutes* at a flow rate of `13`, a total eventual pressure release
  of `28 * 13 = `*`364`*. Then, you could spend your third minute moving
  to valve `CC` and your fourth minute opening it, providing an additional
  *26 minutes* of eventual pressure release at a flow rate of `2`, or
  *`52`* total pressure released by valve `CC`.

  Making your way through the tunnels like this, you could probably open
  many or all of the valves by the time 30 minutes have elapsed. However,
  you need to release as much pressure as possible, so you'll need to be
  methodical. Instead, consider this approach:

      == Minute 1 ==
      No valves are open.
      You move to valve DD.

      == Minute 2 ==
      No valves are open.
      You open valve DD.

      == Minute 3 ==
      Valve DD is open, releasing 20 pressure.
      You move to valve CC.

      == Minute 4 ==
      Valve DD is open, releasing 20 pressure.
      You move to valve BB.

      == Minute 5 ==
      Valve DD is open, releasing 20 pressure.
      You open valve BB.

      == Minute 6 ==
      Valves BB and DD are open, releasing 33 pressure.
      You move to valve AA.

      == Minute 7 ==
      Valves BB and DD are open, releasing 33 pressure.
      You move to valve II.

      == Minute 8 ==
      Valves BB and DD are open, releasing 33 pressure.
      You move to valve JJ.

      == Minute 9 ==
      Valves BB and DD are open, releasing 33 pressure.
      You open valve JJ.

      == Minute 10 ==
      Valves BB, DD, and JJ are open, releasing 54 pressure.
      You move to valve II.

      == Minute 11 ==
      Valves BB, DD, and JJ are open, releasing 54 pressure.
      You move to valve AA.

      == Minute 12 ==
      Valves BB, DD, and JJ are open, releasing 54 pressure.
      You move to valve DD.

      == Minute 13 ==
      Valves BB, DD, and JJ are open, releasing 54 pressure.
      You move to valve EE.

      == Minute 14 ==
      Valves BB, DD, and JJ are open, releasing 54 pressure.
      You move to valve FF.

      == Minute 15 ==
      Valves BB, DD, and JJ are open, releasing 54 pressure.
      You move to valve GG.

      == Minute 16 ==
      Valves BB, DD, and JJ are open, releasing 54 pressure.
      You move to valve HH.

      == Minute 17 ==
      Valves BB, DD, and JJ are open, releasing 54 pressure.
      You open valve HH.

      == Minute 18 ==
      Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
      You move to valve GG.

      == Minute 19 ==
      Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
      You move to valve FF.

      == Minute 20 ==
      Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
      You move to valve EE.

      == Minute 21 ==
      Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
      You open valve EE.

      == Minute 22 ==
      Valves BB, DD, EE, HH, and JJ are open, releasing 79 pressure.
      You move to valve DD.

      == Minute 23 ==
      Valves BB, DD, EE, HH, and JJ are open, releasing 79 pressure.
      You move to valve CC.

      == Minute 24 ==
      Valves BB, DD, EE, HH, and JJ are open, releasing 79 pressure.
      You open valve CC.

      == Minute 25 ==
      Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

      == Minute 26 ==
      Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

      == Minute 27 ==
      Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

      == Minute 28 ==
      Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

      == Minute 29 ==
      Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

      == Minute 30 ==
      Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

  This approach lets you release the most pressure possible in 30 minutes
  with this valve layout, *`1651`*.

  Work out the steps to release the most pressure in 30 minutes. *What is
  the most pressure you can release?*

  """
  def solve_1(data) do
    data
    |> max_released(30, unopened_valves(data))
    |> elem(0)
  end

  @doc """
  # Part 2

  You're worried that even with an optimal approach, the pressure released
  won't be enough. What if you got one of the elephants to help you?

  It would take you 4 minutes to teach an elephant how to open the right
  valves in the right order, leaving you with only *26 minutes* to
  actually execute your plan. Would having two of you working together be
  better, even if it means having less time? (Assume that you teach the
  elephant before opening any valves yourself, giving you both the same
  full 26 minutes.)

  In the example above, you could teach the elephant to help you as
  follows:

      == Minute 1 ==
      No valves are open.
      You move to valve II.
      The elephant moves to valve DD.

      == Minute 2 ==
      No valves are open.
      You move to valve JJ.
      The elephant opens valve DD.

      == Minute 3 ==
      Valve DD is open, releasing 20 pressure.
      You open valve JJ.
      The elephant moves to valve EE.

      == Minute 4 ==
      Valves DD and JJ are open, releasing 41 pressure.
      You move to valve II.
      The elephant moves to valve FF.

      == Minute 5 ==
      Valves DD and JJ are open, releasing 41 pressure.
      You move to valve AA.
      The elephant moves to valve GG.

      == Minute 6 ==
      Valves DD and JJ are open, releasing 41 pressure.
      You move to valve BB.
      The elephant moves to valve HH.

      == Minute 7 ==
      Valves DD and JJ are open, releasing 41 pressure.
      You open valve BB.
      The elephant opens valve HH.

      == Minute 8 ==
      Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
      You move to valve CC.
      The elephant moves to valve GG.

      == Minute 9 ==
      Valves BB, DD, HH, and JJ are open, releasing 76 pressure.
      You open valve CC.
      The elephant moves to valve FF.

      == Minute 10 ==
      Valves BB, CC, DD, HH, and JJ are open, releasing 78 pressure.
      The elephant moves to valve EE.

      == Minute 11 ==
      Valves BB, CC, DD, HH, and JJ are open, releasing 78 pressure.
      The elephant opens valve EE.

      (At this point, all valves are open.)

      == Minute 12 ==
      Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

      ...

      == Minute 20 ==
      Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

      ...

      == Minute 26 ==
      Valves BB, CC, DD, EE, HH, and JJ are open, releasing 81 pressure.

  With the elephant helping, after 26 minutes, the best you could do would
  release a total of *`1707`* pressure.

  *With you and an elephant working together for 26 minutes, what is the
  most pressure you could release?*

  """
  def solve_2(data) do
    unopened = unopened_valves(data)
    minutes_left = 26

    # split unopened into all possible pairs of 2 of "equal" length
    # and find the max for each pair and then the max of those
    unopened
    |> combinations(div(length(unopened), 2))
    |> Task.async_stream(fn unopened1 ->
      unopened2 = unopened -- unopened1
      {s1, _} = max_released(data, minutes_left, unopened1)
      {s2, _} = max_released(data, minutes_left, unopened2)
      s1 + s2
    end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.max()
  end

  # --- </Solution Functions> ---

  def max_released(data, minutes_left, unopened) do
    distances = distances([:AA | unopened], graph(data))
    flows = for %{valve: k, flow_rate: v} <- data, into: %{}, do: {k, v}

    unopened
    |> stops(:AA, distances, minutes_left)
    # |> tap(&IO.puts("Found #{length(&1)} possible paths"))
    |> Enum.map(&{pressure_released([:AA | &1], distances, minutes_left, flows), &1})
    # |> tap(&IO.puts("Scored #{length(&1)} paths"))
    |> Enum.max()
  end

  def graph(data) do
    for %{valve: valve, connections: connections} = room <- data,
        conn <- connections,
        reduce: :digraph.new() do
      g ->
        v1 = :digraph.add_vertex(g, valve, room)
        next_room = Enum.find(data, &(&1.valve == conn))
        v2 = :digraph.add_vertex(g, conn, next_room)
        :digraph.add_edge(g, v1, v2)
        g
    end
  end

  def distances(stops, graph) do
    for from <- stops,
        to <- stops,
        to != from,
        into: %{},
        do: {{from, to}, length(:digraph.get_short_path(graph, from, to))}
  end

  def unopened_valves(rooms) do
    rooms
    |> Enum.filter(&(&1.flow_rate > 0))
    |> Enum.map(& &1.valve)
  end

  def stops([], _from, _distances, _minutes_left), do: [[]]
  def stops(_unopened, _from, _distances, minutes_left) when minutes_left < 1, do: [[]]

  def stops(unopened, from, distances, minutes_left) do
    for to <- unopened,
        rest <-
          stops(List.delete(unopened, to), to, distances, minutes_left - distances[{from, to}]) do
      [to | rest]
    end
  end

  def pressure_released([start | rest], distances, minutes_left, flows) do
    rest
    |> Enum.reduce({0, start, minutes_left}, fn stop, {released, prev, minutes_left} ->
      minutes_left = max(0, minutes_left - distances[{prev, stop}])
      new_release = minutes_left * flows[stop]

      {released + new_release, stop, minutes_left}
    end)
    |> elem(0)
  end

  # Taken from https://github.com/tallakt/comb/blob/be5f9df/lib/comb.ex#L40-L54
  def combinations(enum, k) do
    List.last(do_combinations(enum, k))
    |> Enum.uniq()
  end

  defp do_combinations(enum, k) do
    combinations_by_length = [[[]] | List.duplicate([], k)]

    list = Enum.to_list(enum)

    List.foldr(list, combinations_by_length, fn x, next ->
      sub = :lists.droplast(next)
      step = [[] | for(l <- sub, do: for(s <- l, do: [x | s]))]
      :lists.zipwith(&:lists.append/2, step, next)
    end)
  end
end
