defmodule AdventOfCode.Y2022.Day21 do
  @moduledoc """
  # Day 21: Monkey Math

  Problem Link: https://adventofcode.com/2022/day/21
  """
  use AdventOfCode.Helpers.InputReader, year: 2022, day: 21

  @doc ~S"""
  Sample data:

  ```
  root: pppw + sjmn
  dbpl: 5
  cczh: sllz + lgvd
  zczc: 2
  ptdq: humn - dvpt
  dvpt: 3
  lfqf: 4
  humn: 5
  ljgn: 2
  sjmn: drzm * dbpl
  sllz: 4
  pppw: cczh / lfqf
  lgvd: ljgn * ptdq
  drzm: hmdt - zczc
  hmdt: 32
  ```
  """
  def run(data \\ input!(), part)

  def run(data, part) when is_binary(data), do: data |> parse() |> run(part)

  def run(data, part), do: data |> solve(part)

  def parse(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn
      <<name::binary-size(4), ": ", left::binary-size(4), " ", operator::binary-size(1), " ",
        right::binary-size(4)>> ->
        {name, {left, operator, right}}

      <<name::binary-size(4), ": ", number::binary>> ->
        {name, String.to_integer(number)}
    end)
    |> Enum.into(%{})
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  # Part 1

  The [monkeys](11) are back! You're worried they're going to try to steal
  your stuff again, but it seems like they're just holding their ground
  and making various monkey noises at you.

  Eventually, one of the elephants realizes you don't speak monkey and
  comes over to interpret. As it turns out, they overheard you talking
  about trying to find the grove; they can show you a shortcut if you
  answer their *riddle*.

  Each monkey is given a *job*: either to *yell a specific number* or to
  *yell the result of a math operation*. All of the number-yelling monkeys
  know their number from the start; however, the math operation monkeys
  need to wait for two other monkeys to yell a number, and those two other
  monkeys might *also* be waiting on other monkeys.

  Your job is to *work out the number the monkey named `root` will yell*
  before the monkeys figure it out themselves.

  For example:

    root: pppw + sjmn
    dbpl: 5
    cczh: sllz + lgvd
    zczc: 2
    ptdq: humn - dvpt
    dvpt: 3
    lfqf: 4
    humn: 5
    ljgn: 2
    sjmn: drzm * dbpl
    sllz: 4
    pppw: cczh / lfqf
    lgvd: ljgn * ptdq
    drzm: hmdt - zczc
    hmdt: 32

  Each line contains the name of a monkey, a colon, and then the job of
  that monkey:

  - A lone number means the monkey's job is simply to yell that number.
  - A job like `aaaa + bbbb` means the monkey waits for monkeys `aaaa` and
  `bbbb` to yell each of their numbers; the monkey then yells the sum of
  those two numbers.
  - `aaaa - bbbb` means the monkey yells `aaaa`'s number minus `bbbb`'s
  number.
  - Job `aaaa * bbbb` will yell `aaaa`'s number multiplied by `bbbb`'s
  number.
  - Job `aaaa / bbbb` will yell `aaaa`'s number divided by `bbbb`'s
  number.

  So, in the above example, monkey `drzm` has to wait for monkeys `hmdt`
  and `zczc` to yell their numbers. Fortunately, both `hmdt` and `zczc`
  have jobs that involve simply yelling a single number, so they do this
  immediately: `32` and `2`. Monkey `drzm` can then yell its number by
  finding `32` minus `2`: *`30`*.

  Then, monkey `sjmn` has one of its numbers (`30`, from monkey `drzm`),
  and already has its other number, `5`, from `dbpl`. This allows it to
  yell its own number by finding `30` multiplied by `5`: *`150`*.

  This process continues until `root` yells a number: *`152`*.

  However, your actual situation involves
  <span title="Advent of Code 2022: Now With Considerably More Monkeys">considerably
  more monkeys</span>. *What number will the monkey named `root` yell?*

  """
  def solve_1(data) do
    dfs("root", data)
  end

  defp dfs(monkey, monkey_map) when is_binary(monkey),
    do: dfs(monkey_map[monkey], monkey_map)

  defp dfs(value, _monkey_map) when is_integer(value), do: value

  defp dfs({left, op, right}, monkey_map) do
    eval(dfs(left, monkey_map), op, dfs(right, monkey_map))
  end

  defp eval(left, "+", right), do: left + right
  defp eval(left, "-", right), do: left - right
  defp eval(left, "*", right), do: left * right
  defp eval(left, "/", right), do: div(left, right)

  @doc """
  # Part 2

  Due to some kind of monkey-elephant-human mistranslation, you seem to
  have misunderstood a few key details about the riddle.

  First, you got the wrong job for the monkey named `root`; specifically,
  you got the wrong math operation. The correct operation for monkey
  `root` should be `=`, which means that it still listens for two numbers
  (from the same two monkeys as before), but now checks that the two
  numbers *match*.

  Second, you got the wrong monkey for the job starting with `humn:`. It
  isn't a monkey - it's *you*. Actually, you got the job wrong, too: you
  need to figure out *what number you need to yell* so that `root`'s
  equality check passes. (The number that appears after `humn:` in your
  input is now irrelevant.)

  In the above example, the number you need to yell to pass `root`'s
  equality test is *`301`*. (This causes `root` to get the same number,
  `150`, from both of its monkeys.)

  *What number do you yell to pass `root`'s equality test?*
  """
  def solve_2(data) do
    {root_left, _, root_right} = data["root"]

    {human_side, needed_value} =
      if dfs(root_left, data) != dfs(root_left, Map.update!(data, "humn", &(&1 * &1))),
        do: {root_left, dfs(root_right, data)},
        else: {root_right, dfs(root_left, data)}

    human_path =
      Stream.unfold({"humn", data}, fn
        {^human_side, _} ->
          nil

        {node, tree_data} ->
          parent =
            Enum.find(tree_data, fn
              {_, {^node, _, _}} -> true
              {_, {_, _, ^node}} -> true
              _ -> false
            end)
            |> elem(0)

          {node, {parent, tree_data}}
      end)
      |> Enum.into(MapSet.new())

    data = Map.delete(data, "humn")

    inverse =
      data
      |> Enum.reduce(%{}, fn
        {name, value}, acc when is_integer(value) ->
          Map.put(acc, name, value)

        {name, {left, op, right}}, acc ->
          left = if is_integer(data[left]), do: data[left], else: left
          right = if is_integer(data[right]), do: data[right], else: right

          new_instructions =
            case op do
              "+" -> %{left => {name, "-", right}, right => {name, "-", left}}
              "-" -> %{left => {name, "+", right}, right => {left, "-", name}}
              "*" -> %{left => {name, "/", right}, right => {name, "/", left}}
              "/" -> %{left => {name, "*", right}, right => {left, "/", name}}
            end
            |> Map.filter(fn {k, _} -> is_binary(k) end)

          Map.merge(acc, new_instructions)
      end)
      |> Map.filter(fn {k, _} -> k in human_path end)
      |> Map.put(root_left, needed_value)
      |> Map.put(root_right, needed_value)

    dfs("humn", Map.merge(data, inverse))
  end

  # --- </Solution Functions> ---
end
