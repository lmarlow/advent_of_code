defmodule AdventOfCode.Helpers.InputReader do
  @moduledoc """
  Reads input from file
  """

  defmacro __using__(year: year, day: day) do
    quote do
      def read!(year, day) do
        {:ok, date} = Date.new(year, 12, day)
        path = AdventOfCode.Helpers.Generator.input_file_path(date)

        if not File.exists?(path) do
          AdventOfCode.Helpers.Generator.create_input_file(date)
        end

        File.read!(path)
      end

      def input!, do: read!(unquote(year), unquote(day))
    end
  end
end
