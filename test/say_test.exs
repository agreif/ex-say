defmodule SayTest do
  use ExUnit.Case
  doctest Say

  test "greets the world" do
    assert Say.hello() == :world
  end
end
