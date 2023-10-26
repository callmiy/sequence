defmodule SequenceTest do
  use ExUnit.Case

  test "next/0 next/1 next/2 reset/0" do
    assert 0 = Sequence.next()
    assert 1 = Sequence.next()

    assert "0" = Sequence.next("")
    assert "1" = Sequence.next("")

    assert "name0" = Sequence.next("name")

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

  test "seeded/1 and seeded/2" do
    assert 1 = Sequence.seeded("name", 1)
    assert 2 = Sequence.seeded("name")
    assert 3 = Sequence.seeded("name", 1)

    assert 0 = Sequence.seeded("name1")
  end
end
