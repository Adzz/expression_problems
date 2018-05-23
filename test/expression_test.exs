defmodule ExpressionTest do
  use ExUnit.Case
  doctest Expression

  test "greets the world" do
    assert Expression.hello() == :world
  end
end
