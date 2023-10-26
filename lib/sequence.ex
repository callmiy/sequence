defmodule Sequence do
  use Agent

  @binary_no_name :erlang.unique_integer()
  @list_no_name :erlang.unique_integer()

  @moduledoc """
  Module for generating sequential values.

  Use `Sequence.next/1` or `Sequence.next/2` to generate
  sequential values instead of calling this module directly.
  """

  @doc false
  def start_link(_) do
    Agent.start_link(fn -> Map.new() end, name: __MODULE__)
  end

  @doc """
  Reset all sequences so that the next sequence starts from 0

  ## Example

      Sequence.next("joe") # "joe0"
      Sequence.next("joe") # "joe1"

      Sequence.reset

      Sequence.next("joe") # resets so the return value is "joe0"

  You can use list as well

      Sequence.next(["A", "B"]) # "A"
      Sequence.next(["A", "B"]) # "B"

      Sequence.reset

      Sequence.next(["A", "B"]) # resets so the return value is "A"

  Using formatter
      # Will generate "me-0@foo.com" then "me-1@foo.com", etc.
      Sequence.next(:email, &"me-\#{&1}@foo.com")

      # Will generate "admin" then "user", "other", "admin" etc.
      # `role` is the name of this sequence
      Sequence,next(:role, ["admin", "user", "other"])

  If you want to reset sequences at the beginning of every test, put it in a
  `setup` block in your test.

      setup do
        Sequence.reset
      end
  """

  @spec reset() :: :ok
  def reset do
    Agent.update(__MODULE__, fn _ -> Map.new() end)
  end

  def next(), do: next(@binary_no_name, & &1)
  def next(list) when is_list(list), do: next(@list_no_name, list)

  def next(sequence_name) when is_binary(sequence_name) do
    next(sequence_name, &(sequence_name <> to_string(&1)))
  end

  def next(sequence_name, [_ | _] = list) do
    length = length(list)

    Agent.get_and_update(__MODULE__, fn sequences ->
      current_value = Map.get(sequences, sequence_name, 0)
      index = rem(current_value, length)
      new_sequences = Map.put(sequences, sequence_name, index + 1)
      {value, _} = List.pop_at(list, index)
      {value, new_sequences}
    end)
  end

  def next(sequence_name, formatter) do
    Agent.get_and_update(__MODULE__, fn sequences ->
      current_value = Map.get(sequences, sequence_name, 0)
      new_sequences = Map.put(sequences, sequence_name, current_value + 1)
      {formatter.(current_value), new_sequences}
    end)
  end

  @doc ~S"""
  A sequence generator that can be seeded with a starting value.

  ## Examples

      iex> seeded("name")
      0

      iex> seeded("name")
      1

      iex> seeded("name1", 5)
      5

      iex> seeded("name1")
      6

  """
  def seeded(name, start_value \\ 0) when is_binary(name) do
    name = "seeded-#{name}"

    Agent.get_and_update(__MODULE__, fn sequences ->
      current_value = Map.get(sequences, name, start_value)
      new_sequences = Map.put(sequences, name, current_value + 1)

      {current_value, new_sequences}
    end)
  end
end
