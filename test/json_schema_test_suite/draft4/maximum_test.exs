defmodule JsonSchemaTestSuite.Draft4.MaximumTest do
  use ExUnit.Case

  import JsonXema, only: [valid?: 2]

  describe "maximum validation" do
    setup do
      %{schema: JsonXema.new(%{"maximum" => 3.0})}
    end

    test "below the maximum is valid", %{schema: schema} do
      assert valid?(schema, 2.6)
    end

    test "boundary point is valid", %{schema: schema} do
      assert valid?(schema, 3.0)
    end

    test "above the maximum is invalid", %{schema: schema} do
      refute valid?(schema, 3.5)
    end

    test "ignores non-numbers", %{schema: schema} do
      assert valid?(schema, "x")
    end
  end

  describe "maximum validation (explicit false exclusivity)" do
    setup do
      %{schema: JsonXema.new(%{"exclusiveMaximum" => false, "maximum" => 3.0})}
    end

    test "below the maximum is valid", %{schema: schema} do
      assert valid?(schema, 2.6)
    end

    test "boundary point is valid", %{schema: schema} do
      assert valid?(schema, 3.0)
    end

    test "above the maximum is invalid", %{schema: schema} do
      refute valid?(schema, 3.5)
    end

    test "ignores non-numbers", %{schema: schema} do
      assert valid?(schema, "x")
    end
  end

  describe "exclusiveMaximum validation" do
    setup do
      %{schema: JsonXema.new(%{"exclusiveMaximum" => true, "maximum" => 3.0})}
    end

    test "below the maximum is still valid", %{schema: schema} do
      assert valid?(schema, 2.2)
    end

    test "boundary point is invalid", %{schema: schema} do
      refute valid?(schema, 3.0)
    end
  end
end
