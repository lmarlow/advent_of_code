defmodule AdventOfCode.Y2022.Day20 do
  @moduledoc """
  # Day 20: Grove Positioning System

  Problem Link: https://adventofcode.com/2022/day/20
  """
  use AdventOfCode.Helpers.InputReader, year: 2022, day: 20

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
    |> Enum.map(&String.to_integer/1)
  end

  def solve(data, 1), do: solve_1(data)
  def solve(data, 2), do: solve_2(data)

  # --- <Solution Functions> ---

  @doc """
  # Part 1

  It's finally time to meet back up with the Elves. When you try to
  contact them, however, you get no reply. Perhaps you're out of range?

  You know they're headed to the grove where the *star* fruit grows, so if
  you can figure out where that is, you should be able to meet back up
  with them.

  Fortunately, your handheld device has a file (your puzzle input) that
  contains the grove's coordinates! Unfortunately, the file is
  *encrypted* - just in case the device were to fall into the wrong hands.

  Maybe you can <span
  title="You once again make a mental note to remind the Elves later not to invent their own cryptographic functions.">decrypt</span>
  it?

  When you were still back at the camp, you overheard some Elves talking
  about coordinate file encryption. The main operation involved in
  decrypting the file is called *mixing*.

  The encrypted file is a list of numbers. To *mix* the file, move each
  number forward or backward in the file a number of positions equal to
  the value of the number being moved. The list is *circular*, so moving a
  number off one end of the list wraps back around to the other end as if
  the ends were connected.

  For example, to move the `1` in a sequence like
  `4, 5, 6, `*`1`*`, 7, 8, 9`, the `1` moves one position forward:
  `4, 5, 6, 7, `*`1`*`, 8, 9`. To move the `-2` in a sequence like
  `4, `*`-2`*`, 5, 6, 7, 8, 9`, the `-2` moves two positions backward,
  wrapping around: `4, 5, 6, 7, 8, `*`-2`*`, 9`.

  The numbers should be moved *in the order they originally appear* in the
  encrypted file. Numbers moving around during the mixing process do not
  change the order in which the numbers are moved.

  Consider this encrypted file:

      1
      2
      -3
      3
      -2
      0
      4

  Mixing this file proceeds as follows:

      Initial arrangement:
      1, 2, -3, 3, -2, 0, 4

      1 moves between 2 and -3:
      2, 1, -3, 3, -2, 0, 4

      2 moves between -3 and 3:
      1, -3, 2, 3, -2, 0, 4

      -3 moves between -2 and 0:
      1, 2, 3, -2, -3, 0, 4

      3 moves between 0 and 4:
      1, 2, -2, -3, 0, 3, 4

      -2 moves between 4 and 1:
      1, 2, -3, 0, 3, 4, -2

      0 does not move:
      1, 2, -3, 0, 3, 4, -2

      4 moves between -3 and 0:
      1, 2, -3, 4, 0, 3, -2

  Then, the grove coordinates can be found by looking at the 1000th,
  2000th, and 3000th numbers after the value `0`, wrapping around the list
  as necessary. In the above example, the 1000th number after `0` is
  *`4`*, the 2000th is *`-3`*, and the 3000th is *`2`*; adding these
  together produces *`3`*.

  Mix your encrypted file exactly once. *What is the sum of the three
  numbers that form the grove coordinates?*

  """
  def solve_1(data) do
    decrypted =
      data
      |> decrypt()
      |> Enum.map(fn {d, _} -> d end)

    zero_idx = Enum.find_index(decrypted, &(&1 == 0))

    [1000, 2000, 3000]
    |> Enum.map(&Integer.mod(&1 + zero_idx, length(data)))
    |> Enum.map(&Enum.at(decrypted, &1))
    |> Enum.sum()
  end

  @doc """
  # Part 2

  The grove coordinate values seem nonsensical. While you ponder the
  mysteries of Elf encryption, you suddenly remember the rest of the
  decryption routine you overheard back at camp.

  First, you need to apply the *decryption key*, `811589153`. Multiply
  each number by the decryption key before you begin; this will produce
  the actual list of numbers to mix.

  Second, you need to mix the list of numbers *ten times*. The order in
  which the numbers are mixed does not change during mixing; the numbers
  are still moved in the order they appeared in the original, pre-mixed
  list. (So, if -3 appears fourth in the original list of numbers to mix,
  -3 will be the fourth number to move during each round of mixing.)

  Using the same example as above:

      Initial arrangement:
      811589153, 1623178306, -2434767459, 2434767459, -1623178306, 0, 3246356612

      After 1 round of mixing:
      0, -2434767459, 3246356612, -1623178306, 2434767459, 1623178306, 811589153

      After 2 rounds of mixing:
      0, 2434767459, 1623178306, 3246356612, -2434767459, -1623178306, 811589153

      After 3 rounds of mixing:
      0, 811589153, 2434767459, 3246356612, 1623178306, -1623178306, -2434767459

      After 4 rounds of mixing:
      0, 1623178306, -2434767459, 811589153, 2434767459, 3246356612, -1623178306

      After 5 rounds of mixing:
      0, 811589153, -1623178306, 1623178306, -2434767459, 3246356612, 2434767459

      After 6 rounds of mixing:
      0, 811589153, -1623178306, 3246356612, -2434767459, 1623178306, 2434767459

      After 7 rounds of mixing:
      0, -2434767459, 2434767459, 1623178306, -1623178306, 811589153, 3246356612

      After 8 rounds of mixing:
      0, 1623178306, 3246356612, 811589153, -2434767459, 2434767459, -1623178306

      After 9 rounds of mixing:
      0, 811589153, 1623178306, -2434767459, 3246356612, 2434767459, -1623178306

      After 10 rounds of mixing:
      0, -2434767459, 1623178306, 3246356612, -1623178306, 2434767459, 811589153

  The grove coordinates can still be found in the same way. Here, the
  1000th number after `0` is *`811589153`*, the 2000th is *`2434767459`*,
  and the 3000th is *`-1623178306`*; adding these together produces
  *`1623178306`*.

  Apply the decryption key and mix your encrypted file ten times. *What is
  the sum of the three numbers that form the grove coordinates?*
  """
  def solve_2(data) do
    data_with_ids = Enum.map(data, &(&1 * 811_589_153)) |> Enum.with_index()

    decrypted =
      for _ <- 1..10, reduce: data_with_ids do
        acc ->
          decrypt(data_with_ids, acc, length(data) - 1)
      end
      |> Enum.map(fn {d, _} -> d end)

    zero_idx = Enum.find_index(decrypted, &(&1 == 0))

    [1000, 2000, 3000]
    |> Enum.map(&Integer.mod(&1 + zero_idx, length(data)))
    |> Enum.map(&Enum.at(decrypted, &1))
    |> Enum.sum()
  end

  # --- </Solution Functions> ---

  def decrypt(data) do
    with_ids = Enum.with_index(data)

    decrypt(with_ids, with_ids, length(data) - 1)
  end

  defp decrypt([], data, _), do: data

  defp decrypt([{d, id} | rest], decrypted, available_slots) do
    current_idx = Enum.find_index(decrypted, &(&1 == {d, id}))

    new_idx = current_idx + d

    mod_idx = Integer.mod(new_idx, available_slots)

    decrypt(rest, Enum.slide(decrypted, current_idx, mod_idx), available_slots)
  end
end
