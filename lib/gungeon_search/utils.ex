defmodule GungeonSearch.Utils do
  @moduledoc """
  Utils module for repeated query functions.

  Thanks to Demi for the great levenshtein macros...
  """

  # Wrapper for SQL ILIKE function
  # TODO: implement a real fuzzy string match on multiple words w/ spaces /shrug
  defmacro ilike(str1, str2) do
    quote do
      fragment(
        "? ILIKE ?",
        unquote(str1),
        unquote(str2)
      )
    end
  end
end
