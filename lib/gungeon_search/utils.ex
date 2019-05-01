defmodule GungeonSearch.Utils do
  @moduledoc """
  Utils module for repeated query functions.

  ATTR: http://tech.forwardfinancing.com/elixir/ecto/postgres/fuzzy-search/2017/12/20/fuzzy-search-in-elixir.html
  Thanks to Demi for the great levenshtein macros...
  """

  # Macro that takes two strings and determines if the levenshtein distance
  # between them is less than the given threshold
  defmacro levenshtein(str1, str2, threshold) do
    quote do
      levenshtein(unquote(str1), unquote(str2)) <= unquote(threshold)
    end
  end

  # Wrapper for SQL levenshtein function, which gets the levenshtein distance
  # between str1 and str2
  # SQL levenshtein is case-sensitive, so we downcase everything to make it
  # case-insensitive.
  defmacro levenshtein(str1, str2) do
    quote do
      fragment(
        "levenshtein(LOWER('%' || ? || '%'), LOWER('%' || ? || '%'))",
        unquote(str1),
        unquote(str2)
      )
    end
  end
end
