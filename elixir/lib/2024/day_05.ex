defmodule AdventOfCode.Y2024.Day05 do
  @moduledoc """
  # Day 5: Print Queue

  Problem Link: https://adventofcode.com/2024/day/5
  """
  use AdventOfCode.Helpers.InputReader, year: 2024, day: 5

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

  Satisfied with their search on Ceres, the squadron of scholars suggests
  subsequently scanning the
  <span title="Specifically, the surely-stationary stationery stacks.">stationery</span>
  stacks of sub-basement 17.

  The North Pole printing department is busier than ever this close to
  Christmas, and while The Historians continue their search of this
  historically significant facility, an Elf operating a [very familiar
  printer](/2017/day/1) beckons you over.

  The Elf must recognize you, because they waste no time explaining that
  the new *sleigh launch safety manual* updates won't print correctly.
  Failure to update the safety manuals would be dire indeed, so you offer
  your services.

  Safety protocols clearly indicate that new pages for the safety manuals
  must be printed in a *very specific order*. The notation `X|Y` means
  that if both page number `X` and page number `Y` are to be produced as
  part of an update, page number `X`*must* be printed at some point before
  page number `Y`.

  The Elf has for you both the *page ordering rules* and the *pages to
  produce in each update* (your puzzle input), but can't figure out
  whether each update has the pages in the right order.

  For example:

    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13

    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47

  The first section specifies the *page ordering rules*, one per line. The
  first rule, `47|53`, means that if an update includes both page number
  47 and page number 53, then page number 47 *must* be printed at some
  point before page number 53. (47 doesn't necessarily need to be
  *immediately* before 53; other pages are allowed to be between them.)

  The second section specifies the page numbers of each *update*. Because
  most safety manuals are different, the pages needed in the updates are
  different too. The first update, `75,47,61,53,29`, means that the update
  consists of page numbers 75, 47, 61, 53, and 29.

  To get the printers going as soon as possible, start by identifying
  *which updates are already in the right order*.

  In the above example, the first update (`75,47,61,53,29`) is in the
  right order:

  - `75` is correctly first because there are rules that put each other
  page after it: `75|47`, `75|61`, `75|53`, and `75|29`.
  - `47` is correctly second because 75 must be before it (`75|47`) and
  every other page must be after it according to `47|61`, `47|53`, and
  `47|29`.
  - `61` is correctly in the middle because 75 and 47 are before it
  (`75|61` and `47|61`) and 53 and 29 are after it (`61|53` and
  `61|29`).
  - `53` is correctly fourth because it is before page number 29
  (`53|29`).
  - `29` is the only page left and so is correctly last.

  Because the first update does not include some page numbers, the
  ordering rules involving those missing page numbers are ignored.

  The second and third updates are also in the correct order according to
  the rules. Like the first update, they also do not include every page
  number, and so only some of the ordering rules apply - within each
  update, the ordering rules that involve missing page numbers are not
  used.

  The fourth update, `75,97,47,61,53`, is *not* in the correct order: it
  would print 75 before 97, which violates the rule `97|75`.

  The fifth update, `61,13,29`, is also *not* in the correct order, since
  it breaks the rule `29|13`.

  The last update, `97,13,75,29,47`, is *not* in the correct order due to
  breaking several rules.

  For some reason, the Elves also need to know the *middle page number* of
  each update being printed. Because you are currently only printing the
  correctly-ordered updates, you will need to find the middle page number
  of each correctly-ordered update. In the above example, the
  correctly-ordered updates are:

    75,47,61,53,29
    97,61,53,29,13
    75,29,13

  These have middle page numbers of `61`, `53`, and `29` respectively.
  Adding these page numbers together gives *`143`*.

  Of course, you'll need to be careful: the actual list of *page ordering
  rules* is bigger and more complicated than the above example.

  Determine which updates are already in the correct order. *What do you
  get if you add up the middle page number from those correctly-ordered
  updates?*

  """
  def solve_1(data) do
    {before_rules, later_rules, updates} = parse_data(data)

    for update <- updates, update_valid?(update, [], before_rules, later_rules), reduce: 0 do
      acc -> acc + Enum.at(update, div(Enum.count(update), 2))
    end
  end

  @doc """
  # Part 2
  While the Elves get to work printing the correctly-ordered updates, you have a little time to fix the rest of them.

  For each of the incorrectly-ordered updates, use the page ordering rules to
  put the page numbers in the right order. For the above example, here are the
  three incorrectly-ordered updates and their correct orderings:

  - 75,97,47,61,53 becomes 97,75,47,61,53.
  - 61,13,29 becomes 61,29,13.
  - 97,13,75,29,47 becomes 97,75,47,29,13.

  After taking only the incorrectly-ordered updates and ordering them
  correctly, their middle page numbers are 47, 29, and 47. Adding these
  together produces 123.

  Find the updates which are not in the correct order. What do you get if you
  add up the middle page numbers after correctly ordering just those updates?
  """
  def solve_2(data) do
    {before_rules, later_rules, updates} = parse_data(data)

    for update <- updates, not update_valid?(update, [], before_rules, later_rules), reduce: 0 do
      acc ->
        sorted = Enum.sort(update, &(&2 in Map.get(before_rules, &1, [])))
        acc + Enum.at(sorted, div(Enum.count(update), 2))
    end
  end

  # --- </Solution Functions> ---
  defp update_valid?([], _previous_pages, _before_rules, _later_rules), do: true

  defp update_valid?([page | remaining_pages], previous_pages, before_rules, later_rules) do
    if Enum.any?(remaining_pages, &(page in Map.get(before_rules, &1, []))) or
         Enum.any?(previous_pages, &(page in Map.get(later_rules, &1, []))) do
      false
    else
      update_valid?(remaining_pages, [page | previous_pages], before_rules, later_rules)
    end
  end

  defp parse_data(data) do
    {rules, updates} =
      for line <- data, reduce: {[], []} do
        {rules, updates} ->
          case line do
            <<first::binary-size(2), "|", later::binary-size(2)>> ->
              {[{String.to_integer(first), String.to_integer(later)} | rules], updates}

            "" ->
              {rules, updates}

            line ->
              update =
                line |> String.split(",") |> Enum.map(&String.to_integer/1)

              {rules, [update | updates]}
          end
      end

    {rules, updates} = {Enum.reverse(rules), Enum.reverse(updates)}

    before_rules =
      rules
      |> Enum.group_by(fn {before, _later} -> before end, fn {_before, later} -> later end)

    later_rules =
      rules
      |> Enum.group_by(fn {_before, later} -> later end, fn {before, _later} -> before end)

    {before_rules, later_rules, updates}
  end
end
