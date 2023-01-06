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

  defstruct valve: nil, flow_rate: 0, connections: [], open?: false

  @doc """
      Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
  """
  def parse(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&Parser.line/1)
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(fn [valve, flow_rate | connections] ->
      {valve,
       struct(__MODULE__,
         valve: String.to_atom(valve),
         flow_rate: flow_rate,
         connections: Enum.map(connections, &String.to_atom/1),
         open?: flow_rate == 0
       )}
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
  def solve_1([{start_room, _} | _rest] = data) do
    by_room = Enum.into(data, %{})

    graph =
      for {valve, %{connections: connections} = room} <- data,
          conn <- connections,
          reduce: :digraph.new() do
        g ->
          v1 = :digraph.add_vertex(g, valve, room)
          next_room = Map.get(by_room, conn)
          v2 = :digraph.add_vertex(g, conn, next_room)
          :digraph.add_edge(g, v1, v2)
          g
      end

    # paths(
    #   unopened_valves(Map.values(by_room)),
    #   {start_room, 0},
    #   graph
    # )
    # # |> Enum.map(&elem(&1, 1))
    # |> Enum.map(&pressure_released(&1, by_room))
    # |> Enum.sort(:desc)
    # |> hd()

    {by_room, graph}
  end

  @doc """
  # Part 2
  """
  def solve_2(data) do
    {2, :not_implemented, data}
  end

  # --- </Solution Functions> ---

  def unopened_valves(rooms) do
    rooms
    |> Enum.reject(& &1.open?)
    |> Enum.sort_by(& &1.flow_rate, :desc)
    |> Enum.map(&{&1.valve, &1.flow_rate})
  end

  def paths(unopened, from, graph) do
    compute_paths(
      unopened,
      from,
      graph,
      _acc = {_minutes_left = 30, _open_flow = 0, _path_flow = 0, _current_path = [], _paths = []}
    )
  end

  def compute_paths(
        _unopened,
        _from,
        _graph,
        {_minutes_left = 0, __open_flow, _path_flow, current_path, paths}
      ),
      do: [current_path | paths]

  def compute_paths(
        [],
        {last_to_open, _flow_rate},
        _graph,
        {minutes_left, open_flow, _path_flow, current_path, paths}
      ),
      do: [
        Enum.concat(current_path, List.duplicate({last_to_open, open_flow}, minutes_left)) | paths
      ]

  def compute_paths(
        unopened,
        {from_room, _},
        graph,
        {minutes_left, open_flow, path_flow, current_path, paths}
      ) do
    for {next_to_open, room_flow_rate} = this <- unopened,
        rest = unopened -- [this],
        reduce: paths do
      paths ->
        case :digraph.get_short_path(graph, from_room, next_to_open) do
          next_leg when length(next_leg) > minutes_left ->
            [
              Enum.concat(current_path, List.duplicate({from_room, open_flow}, minutes_left))
              | paths
            ]

          next_leg ->
            travel_time = length(next_leg) - 1
            next_leg = Enum.map()

            new_flow = open_flow + room_flow_rate

            compute_paths(
              rest,
              this,
              graph,
              {minutes_left - 1 - travel_time, new_flow,
               open_flow + path_flow + travel_time * new_flow,
               Enum.concat(current_path, next_leg), paths}
            )
        end
    end
  end

  def pressure_released(path, by_room, minutes_left \\ 30, open_flow \\ 0, released \\ 0)

  def pressure_released(_path, _, 0, _, released), do: released

  def pressure_released([], _, minutes_left, open_flow, released),
    do: released + minutes_left * open_flow

  def pressure_released(
        [room | [room | _] = rest],
        by_room,
        minutes_left,
        open_flow,
        released
      ),
      do:
        pressure_released(
          rest,
          by_room,
          minutes_left - 1,
          open_flow + Map.get(by_room, room).flow_rate,
          released + open_flow
        )

  def pressure_released([_new_room | rest], by_room, minutes_left, open_flow, released),
    do:
      pressure_released(
        rest,
        by_room,
        minutes_left - 1,
        open_flow,
        released + open_flow
      )
end
