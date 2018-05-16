defmodule Draft4.DependenciesTest do
  use ExUnit.Case, async: true

  import JsonXema, only: [is_valid?: 2]

  describe "dependencies" do
    setup do
      %{schema: JsonXema.new(~s( {"dependencies":{"bar":["foo"]}} ))}
    end

    test "neither", %{schema: schema} do
      data = %{}
      assert is_valid?(schema, data)
    end

    test "nondependant", %{schema: schema} do
      data = %{foo: 1}
      assert is_valid?(schema, data)
    end

    test "with dependency", %{schema: schema} do
      data = %{bar: 2, foo: 1}
      assert is_valid?(schema, data)
    end

    test "missing dependency", %{schema: schema} do
      data = %{bar: 2}
      refute is_valid?(schema, data)
    end

    test "ignores arrays", %{schema: schema} do
      data = ["bar"]
      assert is_valid?(schema, data)
    end

    test "ignores strings", %{schema: schema} do
      data = "foobar"
      assert is_valid?(schema, data)
    end

    test "ignores other non-objects", %{schema: schema} do
      data = 12
      assert is_valid?(schema, data)
    end
  end

  describe "multiple dependencies" do
    setup do
      %{schema: JsonXema.new(~s( {"dependencies":{"quux":["foo","bar"]}} ))}
    end

    test "neither", %{schema: schema} do
      data = %{}
      assert is_valid?(schema, data)
    end

    test "nondependants", %{schema: schema} do
      data = %{bar: 2, foo: 1}
      assert is_valid?(schema, data)
    end

    test "with dependencies", %{schema: schema} do
      data = %{bar: 2, foo: 1, quux: 3}
      assert is_valid?(schema, data)
    end

    test "missing dependency", %{schema: schema} do
      data = %{foo: 1, quux: 2}
      refute is_valid?(schema, data)
    end

    test "missing other dependency", %{schema: schema} do
      data = %{bar: 1, quux: 2}
      refute is_valid?(schema, data)
    end

    test "missing both dependencies", %{schema: schema} do
      data = %{quux: 1}
      refute is_valid?(schema, data)
    end
  end

  describe "multiple dependencies subschema" do
    setup do
      %{
        schema:
          JsonXema.new(
            ~s( {"dependencies":{"bar":{"properties":{"bar":{"type":"integer"},"foo":{"type":"integer"}}}}} )
          )
      }
    end

    test "valid", %{schema: schema} do
      data = %{bar: 2, foo: 1}
      assert is_valid?(schema, data)
    end

    test "no dependency", %{schema: schema} do
      data = %{foo: "quux"}
      assert is_valid?(schema, data)
    end

    test "wrong type", %{schema: schema} do
      data = %{bar: 2, foo: "quux"}
      refute is_valid?(schema, data)
    end

    test "wrong type other", %{schema: schema} do
      data = %{bar: "quux", foo: 2}
      refute is_valid?(schema, data)
    end

    test "wrong type both", %{schema: schema} do
      data = %{bar: "quux", foo: "quux"}
      refute is_valid?(schema, data)
    end
  end
end
