defmodule SequenceTest do
  use ExUnit.Case

  test "next/0 next/1 next/2 reset/0" do
    assert 0 = Sequence.next()
    assert 1 = Sequence.next()

    assert "0" = Sequence.next("")
    assert "1" = Sequence.next("")

    assert "A" == Sequence.next(["A", "B"])
    assert "B" == Sequence.next(["A", "B"])
    assert "A" == Sequence.next(["A", "B"])

    assert "A" == Sequence.next("", ["A", "B"])
    assert "B" == Sequence.next("", ["A", "B"])
    assert "A" == Sequence.next("", ["A", "B"])

    assert :ok = Sequence.reset()

    assert 0 = Sequence.next()
    assert "0" = Sequence.next("")
  end
end
