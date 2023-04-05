defmodule MaxoTest do
  use ExUnit.Case
  doctest Maxo

  test "greets the world" do
    assert Maxo.hello() == :world
  end
end
