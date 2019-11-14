defmodule Forum.EventTest do
  use ExUnit.Case, async: true

  test "events have String.Chars implementation" do
    assert "#{Forum.TestEventOne.new(42)}" == "%Forum.TestEventOne{life: 42}"
  end
end
