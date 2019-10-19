defmodule JsonSchemaTestSuite.Draft4.MaxPropertiesTest do
  use ExUnit.Case

  import JsonXema, only: [valid?: 2]

  describe "maxProperties validation" do
    setup do
      %{schema: JsonXema.new(%{"maxProperties" => 2})}
    end

    test "shorter is valid", %{schema: schema} do
      assert valid?(schema, %{"foo" => 1})
    end

    test "exact length is valid", %{schema: schema} do
      assert valid?(schema, %{"bar" => 2, "foo" => 1})
    end

    test "too long is invalid", %{schema: schema} do
      refute valid?(schema, %{"bar" => 2, "baz" => 3, "foo" => 1})
    end

    test "ignores arrays", %{schema: schema} do
      assert valid?(schema, [1, 2, 3])
    end

    test "ignores strings", %{schema: schema} do
      assert valid?(schema, "foobar")
    end

    test "ignores other non-objects", %{schema: schema} do
      assert valid?(schema, 12)
    end
  end
end
