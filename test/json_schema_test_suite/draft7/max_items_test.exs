defmodule JsonSchemaTestSuite.Draft7.MaxItemsTest do
  use ExUnit.Case

  import JsonXema, only: [valid?: 2]

  describe "maxItems validation" do
    setup do
      %{schema: JsonXema.new(%{"maxItems" => 2})}
    end

    test "shorter is valid", %{schema: schema} do
      assert valid?(schema, [1])
    end

    test "exact length is valid", %{schema: schema} do
      assert valid?(schema, [1, 2])
    end

    test "too long is invalid", %{schema: schema} do
      refute valid?(schema, [1, 2, 3])
    end

    test "ignores non-arrays", %{schema: schema} do
      assert valid?(schema, "foobar")
    end
  end
end
