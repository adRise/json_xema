defmodule Draft7.ExclusiveMaximumTest do
  use ExUnit.Case, async: true

  import JsonXema, only: [valid?: 2]

  describe "exclusiveMaximum validation" do
    setup do
      %{schema: JsonXema.new(~s(
        {
          "exclusiveMaximum": 3.0
        }
      ))}
    end

    test "below the exclusiveMaximum is valid", %{schema: schema} do
      data = 2.2
      assert valid?(schema, data)
    end

    test "boundary point is invalid", %{schema: schema} do
      data = 3.0
      refute valid?(schema, data)
    end

    test "above the exclusiveMaximum is invalid", %{schema: schema} do
      data = 3.5
      refute valid?(schema, data)
    end

    test "ignores non-numbers", %{schema: schema} do
      data = "x"
      assert valid?(schema, data)
    end
  end
end
