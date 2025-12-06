defmodule AdventOfCode.Helpers.Generator do
  @moduledoc """
  Module responsible for writing the generated code.
  """

  @code_template "lib/helpers/templates/code.eex"
  @test_template "lib/helpers/templates/test.eex"
  @livebook_template "lib/helpers/templates/livebook.eex"
  @part2_replace_text "PROBLEM_TEXT_PART2"

  @doc """
  Generates the necessary artifacts for solving a day's problem.

  Given {year, day} as input, it creates the following-

  - Input file fetched from advent of code site and saved at `priv/input_files/` as `<year>_<day>.txt` file.
  - Code file containing boilerplate code saved at `lib/<year>/day_<day>.ex` file
  - Test cases containing default tests for `run_1` and `run_2` at `test/<year>/day_<day>_test.exs` file
  """
  @spec run({integer(), integer()}) :: String.t()
  def run({year, day}) do
    _ = Application.ensure_all_started(:req)

    {:ok, date} = Date.new(year, 12, day)

    input_file = create_input_file(date)

    code_dir = Path.join("lib", to_string(year))
    test_dir = Path.join("test", to_string(year))
    ensure_directories([code_dir, test_dir])

    day_doc = get_day_doc(year, day)
    title = get_title(day_doc)
    problem_text_part1 = get_problem_text(day_doc, [])
    problem_text_part2 = get_problem_text(day_doc, [{"id", "part2"}]) || @part2_replace_text
    example_data = get_example_data(day_doc)

    [code_filename, test_filename, livebook_filename] =
      for suffix <- ~w[.ex _test.exs .livemd] do
        Calendar.strftime(date, "day_%d") <> suffix
      end

    # Write code files at `lib/<year>/day_<day>.ex`
    code_content =
      @code_template
      |> EEx.eval_file(
        day: day,
        year: year,
        title: title,
        problem_text_part1: problem_text_part1,
        problem_text_part2: problem_text_part2,
        date: date
      )

    code_path = Path.join(code_dir, code_filename)

    code_file =
      code_path
      |> Mix.Generator.create_file(code_content)

    # Write test files at `test/<year>/day_<year>_test.exs`
    test_content =
      @test_template
      |> EEx.eval_file(day: day, year: year, date: date, example_data: example_data)

    test_path = Path.join(test_dir, test_filename)

    test_file =
      test_path
      |> Mix.Generator.create_file(test_content)

    # Write code files at `lib/<year>/day_<day>.ex`
    livebook_content =
      @livebook_template
      |> EEx.eval_file(
        day: day,
        year: year,
        title: title,
        problem_text_part1: problem_text_part1,
        problem_text_part2: problem_text_part2,
        date: date
      )

    livebook_path = Path.join(code_dir, livebook_filename)

    livebook_file =
      livebook_path
      |> Mix.Generator.create_file(livebook_content)

    System.shell("mix format -- #{code_path} #{test_path}")

    "INPUT: #{input_file}\tCODE: #{code_file}\tTEST: #{test_file}\tLIVEBOOK: #{livebook_file}\n"
  end

  def part2({year, day}) do
    _ = Application.ensure_all_started(:req)

    part2_text =
      year
      |> get_day_doc(day)
      |> get_problem_text([{"id", "part2"}])

    if part2_text do
      {:ok, date} = Date.new(year, 12, day)
      code_dir = Path.join("lib", to_string(year))

      [code_filename, _test_filename, livebook_filename] =
        for suffix <- ~w[.ex _test.exs .livemd] do
          Calendar.strftime(date, "day_%d") <> suffix
        end

      code_path = Path.join(code_dir, code_filename)
      livebook_path = Path.join(code_dir, livebook_filename)

      for path <- [code_path, livebook_path] do
        with {:ok, content} <- File.read(path),
             updated_content = String.replace(content, @part2_replace_text, part2_text),
             true <- Mix.shell().yes?("Overwrite #{path}?"),
             :ok <- File.write(path, updated_content) do
          System.shell("mix format -- #{path}")
          Mix.shell().info("Updated part 2 text in #{path}")
        else
          false ->
            Mix.shell().info("Skipped #{path}")

          other ->
            Mix.shell().error(inspect(other))
        end
      end
    end
  end

  defp get_day_input(year, day) do
    url = "https://adventofcode.com/#{year}/day/#{day}/input"

    with {:ok, %{status: 200, body: body}} <-
           Req.get(url, headers: [{"cookie", "session=#{System.get_env("COOKIE", "")}"}]) do
      {:ok, body}
    end
  end

  defp input_filename(date), do: Calendar.strftime(date, "%Y_%d.txt")

  def input_file_path(date),
    do: Path.join([input_dir(), to_string(date.year), input_filename(date)])

  defp input_dir, do: Path.join("priv", "input_files")

  def create_input_file(date) do
    input_dir = input_dir()
    build_priv_dir = Path.join(:code.priv_dir(:advent_of_code), "input_files")
    ensure_directories([input_dir, build_priv_dir])

    # Write the input data at `priv/input_files`
    input_file_path = input_file_path(date)
    build_priv_file_path = String.replace(input_file_path, input_dir, build_priv_dir)

    with {:ok, data} <- get_day_input(date.year, date.day),
         true <- Mix.Generator.create_file(input_file_path, data) do
      Mix.Generator.copy_file(input_file_path, build_priv_file_path)
    else
      _other -> false
    end
  end

  def get_day_doc(year, day) do
    url = "https://adventofcode.com/#{year}/day/#{day}"

    with {:ok, %{status: 200, body: body}} <-
           Req.get(url, headers: [{"cookie", "session=#{System.get_env("COOKIE", "")}"}]),
         {:ok, parsed_body} <- Floki.parse_document(body) do
      parsed_body
    end
  end

  defp get_title(doc) do
    doc
    |> Floki.find("article.day-desc h2")
    |> Enum.find_value("", fn
      {"h2", [], [title | _]} ->
        title |> String.trim("-") |> String.trim()

      _other ->
        false
    end)
  end

  defp get_problem_text(doc, h2_attrs) do
    doc
    |> Floki.find("article.day-desc")
    |> Enum.find_value(fn
      {"article", _, [{"h2", ^h2_attrs, _} | problem_doc]} ->
        problem_doc
        |> Floki.raw_html()
        |> Pandex.html_to_gfm()
        |> then(fn
          {:ok, markdown} ->
            markdown

          _ ->
            ""
        end)

      _other ->
        false
    end)
  end

  defp get_example_data(doc) do
    with [{"code", _, [example]} | _others] when is_binary(example) <-
           Floki.find(doc, "main article pre code") do
      String.trim(example)
    else
      _other -> ""
    end
  end

  defp ensure_directories(paths) do
    for dir <- paths, not File.dir?(dir) do
      File.mkdir_p!(dir)
    end
  end
end
