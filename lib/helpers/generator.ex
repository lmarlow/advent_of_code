defmodule AdventOfCode.Helpers.Generator do
  @moduledoc """
  Module responsible for writing the generated code.
  """

  @code_template "lib/helpers/templates/code.eex"
  @test_template "lib/helpers/templates/test.eex"
  @livebook_template "lib/helpers/templates/livebook.eex"

  @doc """
  Generates the necessary artifacts for solving a day's problem.

  Given {year, day} as input, it creates the following-

  - Input file fetched from advent of code site and saved at `priv/input_files/` as `<year>_<day>.txt` file.
  - Code file containing boilerplate code saved at `lib/<year>/day_<day>.ex` file
  - Test cases containing default tests for `run_1` and `run_2` at `test/<year>/day_<day>_test.exs` file
  """
  @spec run({integer(), integer()}) :: String.t()
  def run({year, day}) do
    input_dir = Path.join("priv", "input_files")
    build_priv_dir = Path.join(:code.priv_dir(:advent_of_code), "input_files")
    code_dir = Path.join("lib", to_string(year))
    test_dir = Path.join("test", to_string(year))

    for dir <- [input_dir, build_priv_dir, code_dir, test_dir], not File.dir?(dir) do
      File.mkdir_p!(dir)
    end

    # Write the input data at `priv/input_files`
    input_file_path = Path.join(input_dir, "#{year}_#{zero_padded(day)}.txt")

    build_priv_file_path = Path.join(build_priv_dir, "#{year}_#{zero_padded(day)}.txt")

    input_file =
      input_file_path
      |> create_input_file(year, day)

    Mix.Generator.copy_file(input_file_path, build_priv_file_path)

    # Write code files at `lib/<year>/day_<day>.ex`
    code_content =
      @code_template
      |> EEx.eval_file(day: day, year: year, title: get_title(year, day))

    code_file =
      code_dir
      |> Path.join("day_#{zero_padded(day)}.ex")
      |> create_file(code_content)

    # Write test files at `test/<year>/day_<year>_test.exs`
    test_content =
      @test_template
      |> EEx.eval_file(day: day, year: year)

    test_file =
      test_dir
      |> Path.join("day_#{zero_padded(day)}_test.exs")
      |> create_file(test_content)

    # Write code files at `lib/<year>/day_<day>.ex`
    livebook_content =
      @livebook_template
      |> EEx.eval_file(day: day, year: year, title: get_title(year, day))

    livebook_file =
      code_dir
      |> Path.join("day_#{zero_padded(day)}.livemd")
      |> create_file(livebook_content)

    "INPUT: #{input_file}\tCODE: #{code_file}\tTEST: #{test_file}\tLIVEBOOK: #{livebook_file}\n"
  end

  defp create_file(path, content) do
    Mix.Generator.create_file(path, content)
  end

  defp fetch_cookie(year, day) do
    HTTPoison.start()

    "https://adventofcode.com/#{year}/day/#{day}/input"
    |> HTTPoison.get([{"cookie", "session=#{System.get_env("COOKIE", "")}"}])
    |> then(fn response ->
      case response do
        {:ok, %HTTPoison.Response{body: body}} -> {:ok, body}
        _ -> nil
      end
    end)
  end

  defp create_input_file(path, year, day) do
    with {:ok, data} <- fetch_cookie(year, day) do
      Mix.Generator.create_file(path, data)
    end
  end

  defp get_title(year, day) do
    HTTPoison.start()

    "https://adventofcode.com/#{year}/day/#{day}"
    |> HTTPoison.get()
    |> then(fn response ->
      case response do
        {:ok, %HTTPoison.Response{body: body}} -> body
        _ -> nil
      end
    end)
    |> Floki.parse_document!()
    |> Floki.find("h2")
    |> then(fn [{"h2", [], [title | _]}] -> title end)
  rescue
    _ -> ""
  end

  defp zero_padded(day), do: day |> to_string() |> String.pad_leading(2, "0")
end
