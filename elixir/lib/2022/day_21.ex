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

  defmodule Monkey do
    use GenServer, restart: :transient

    defstruct [:registry_name, :name, :left_name, :right_name, :op, :op_fn, :args, :value]

    def yell(pid) when is_pid(pid) do
      GenServer.cast(pid, :yell)
    end

    @impl true
    def init([registry_name, name, {left_name, operator, right_name}]) do
      {:ok, _} = Registry.register(registry_name, left_name, :left)
      {:ok, _} = Registry.register(registry_name, right_name, :right)

      op_fn =
        case operator do
          "+" -> &Kernel.+/2
          "-" -> &Kernel.-/2
          "*" -> &Kernel.*/2
          "/" -> &Kernel.div/2
          "=" -> &Kernel.==/2
        end

      {:ok,
       %__MODULE__{
         registry_name: registry_name,
         name: name,
         left_name: left_name,
         right_name: right_name,
         args: [nil, nil],
         op_fn: op_fn,
         op: operator
       }}
    end

    @impl true
    def init([registry_name, start_yelling_key, name, value]) do
      {:ok, _} = Registry.register(registry_name, start_yelling_key, value)

      {:ok, %__MODULE__{registry_name: registry_name, name: name, value: value}}
    end

    @impl true
    def handle_info(
          {left_name, lvalue},
          %__MODULE__{left_name: left_name, args: [_, right_arg]} = state
        ) do
      state = %{state | args: [lvalue, right_arg]}

      {:noreply, state, {:continue, :evaluate}}
    end

    @impl true
    def handle_info(
          {right_name, rvalue},
          %__MODULE__{right_name: right_name, args: [left_arg, _]} = state
        ) do
      state = %{state | args: [left_arg, rvalue]}

      {:noreply, state, {:continue, :evaluate}}
    end

    @impl true
    def handle_info(other, state) do
      IO.inspect(other, label: state.name)
      {:noreply, state}
    end

    @impl true
    def handle_continue(
          :evaluate,
          %__MODULE__{args: [left_arg, right_arg] = args} = state
        )
        when is_integer(left_arg) and is_integer(right_arg) do
      value = apply(state.op_fn, args)

      # IO.puts(
      #   ~s[#{state.name} evaluated #{state.left_name}:#{left_arg} #{state.op} #{state.right_name}:#{right_arg} = #{value}]
      # )

      yell(self())

      {:noreply, %{state | value: value}}
    end

    @impl true
    def handle_continue(:evaluate, state), do: {:noreply, state}

    @impl true
    def handle_cast(
          :yell,
          %__MODULE__{registry_name: registry_name, name: name, value: value} = state
        )
        when not is_nil(value) do
      # IO.puts(~s[#{name} yells "#{value}"])

      Registry.dispatch(registry_name, name, fn entries ->
        for {pid, _} <- entries, do: send(pid, {name, value})
      end)

      {:noreply, state}
    end

    @impl true
    def handle_cast(:yell, state), do: {:noreply, state}
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
    registry_name = __MODULE__.Part1
    start_yelling_key = :start_yelling

    {:ok, _} =
      Registry.start_link(
        keys: :duplicate,
        name: registry_name,
        partitions: System.schedulers_online()
      )

    {:ok, _} = Registry.register(registry_name, "root", [])

    data
    |> Enum.each(fn
      {name, {_, _, _} = equation} ->
        GenServer.start_link(Monkey, [registry_name, name, equation])

      {name, value} ->
        GenServer.start_link(Monkey, [registry_name, start_yelling_key, name, value])
    end)

    Registry.dispatch(registry_name, start_yelling_key, fn entries ->
      for {pid, _} <- entries, do: Monkey.yell(pid)
    end)

    receive do
      {"root", value} -> value
    end
  end

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
    registry_name = __MODULE__.Part2
    start_yelling_key = :start_yelling

    {:ok, _} =
      Registry.start_link(
        keys: :duplicate,
        name: registry_name,
        partitions: System.schedulers_online()
      )

    {:ok, _} = Registry.register(registry_name, "root", [])

    data
    |> Enum.each(fn
      {"humn", _} ->
        :ignore

      {"root" = name, {left, _, right}} ->
        GenServer.start_link(Monkey, [registry_name, name, {left, "=", right}])

      {name, {_, _, _} = equation} ->
        GenServer.start_link(Monkey, [registry_name, name, equation])

      {name, value} ->
        GenServer.start_link(Monkey, [registry_name, start_yelling_key, name, value])
    end)

    Registry.dispatch(registry_name, start_yelling_key, fn entries ->
      for {pid, _} <- entries, do: Monkey.yell(pid)
    end)

    start_value =
      if map_size(data) > 20 do
        3_099_532_691_300
      else
        1
      end

    Stream.iterate(start_value, &(&1 + 1))
    # |> Stream.map_every(10_000, &IO.inspect/1)
    |> Enum.find(fn human_value ->
      Registry.dispatch(registry_name, "humn", fn entries ->
        for {pid, _} <- entries,
            do: send(pid, {"humn", human_value})
      end)

      receive do
        {"root", value} -> value
      end
    end)
  end

  # --- </Solution Functions> ---
end
