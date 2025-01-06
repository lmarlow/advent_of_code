defmodule AdventOfCode.Y2024.Day03 do
  @moduledoc """
  # Day 3: Mull It Over

  Problem Link: https://adventofcode.com/2024/day/3
  """
  use AdventOfCode.Helpers.InputReader, year: 2024, day: 3

  defmodule Parser do
    import NimbleParsec

    mul =
      ignore(string("mul("))
      |> integer(min: 1, max: 3)
      |> ignore(string(","))
      |> integer(min: 1, max: 3)
      |> ignore(string(")"))
      |> tag(:mul)

    enable = string("do()") |> replace(true) |> unwrap_and_tag(:enable)
    disable = string("don't()") |> replace(false) |> unwrap_and_tag(:enable)

    defparsec(:mul_instruction, eventually(mul))

    defparsec(:fancy_mul_instruction, eventually(choice([disable, enable, mul])))
  end

  @doc ~S"""
  Sample data:

  ```
  ```
  """
  def run(data \\ input!(), part)

  def run(data, part), do: data |> solve(part)

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  # Part 1

  "Our computers are having issues, so I have no idea if we have any Chief
  Historians
  <span title="There's a spot reserved for Chief Historians between the green toboggans and the red toboggans. They've never actually had any Chief Historians in stock, but it's best to be prepared.">in
  stock</span>! You're welcome to check the warehouse, though," says the
  mildly flustered shopkeeper at the [North Pole Toboggan Rental
  Shop](/2020/day/2). The Historians head out to take a look.

  The shopkeeper turns to you. "Any chance you can see why our computers
  are having issues again?"

  The computer appears to be trying to run a program, but its memory (your
  puzzle input) is *corrupted*. All of the instructions have been jumbled
  up!

  It seems like the goal of the program is just to *multiply some
  numbers*. It does that with instructions like `mul(X,Y)`, where `X` and
  `Y` are each 1-3 digit numbers. For instance, `mul(44,46)` multiplies
  `44` by `46` to get a result of `2024`. Similarly, `mul(123,4)` would
  multiply `123` by `4`.

  However, because the program's memory has been corrupted, there are also
  many invalid characters that should be *ignored*, even if they look like
  part of a `mul` instruction. Sequences like `mul(4*`, `mul(6,9!`,
  `?(12,34)`, or `mul ( 2 , 4 )` do *nothing*.

  For example, consider the following section of corrupted memory:

    xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))

  Only the four highlighted sections are real `mul` instructions. Adding
  up the result of each instruction produces *`161`*
  (`2*4 + 5*5 + 11*8 + 8*5`).

  Scan the corrupted memory for uncorrupted `mul` instructions. *What do
  you get if you add up all of the results of the multiplications?*

  """
  def solve_1(data) do
    data
    |> Parser.mul_instruction()
    |> collect_instructions([], &Parser.mul_instruction/1)
    |> Enum.map(fn {:mul, [a, b]} -> a * b end)
    |> Enum.sum()
  end

  @doc """
  # Part 2

  As you scan through the corrupted memory, you notice that some of the
  conditional statements are also still intact. If you handle some of the
  uncorrupted conditional statements in the program, you might be able to get an
  even more accurate result.

  There are two new instructions you'll need to handle:

  The do() instruction enables future mul instructions. The don't() instruction
  disables future mul instructions. Only the most recent do() or don't()
  instruction applies. At the beginning of the program, mul instructions are
  enabled.

  For example:

  xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5)) This
  corrupted memory is similar to the example from before, but this time the
  mul(5,5) and mul(11,8) instructions are disabled because there is a don't()
  instruction before them. The other mul instructions function normally,
  including the one at the end that gets re-enabled by a do() instruction.

  This time, the sum of the results is 48 (2*4 + 8*5).

  Handle the new instructions; what do you get if you add up all of the results
  of just the enabled multiplications?
  """
  def solve_2(data) do
    data
    |> Parser.fancy_mul_instruction()
    |> collect_instructions([], &Parser.fancy_mul_instruction/1)
    |> Enum.reduce({true, 0}, fn
      {:enable, true}, {_enable, sum} -> {true, sum}
      {:enable, false}, {_enable, sum} -> {false, sum}
      {:mul, [a, b]}, {true, sum} -> {true, sum + a * b}
      _, {false, sum} -> {false, sum}
    end)
    |> elem(1)
  end

  # --- </Solution Functions> ---
  defp collect_instructions({:ok, args, rest, _context, _line, _column}, acc, parsec) do
    rest
    |> parsec.()
    |> collect_instructions([args | acc], parsec)
  end

  defp collect_instructions({:error, _error, _rest, _context, _line, _column}, acc, _parsec) do
    acc
    |> Enum.reverse()
    |> List.flatten()
  end
end
