defmodule Draft4.DefinitionsTest do
  use ExUnit.Case, async: true

  import JsonXema, only: [valid?: 2]

  describe "valid definition" do
    setup do
      %{schema: JsonXema.new(~s(
        {
          "$ref": "http://json-schema.org/draft-04/schema#"
        }
      ))}
    end

    test "valid definition schema", %{schema: schema} do
      data = %{"definitions" => %{"foo" => %{"type" => "integer"}}}
      assert valid?(schema, data)
    end
  end

  describe "invalid definition" do
    setup do
      %{schema: JsonXema.new(~s(
        {
          "$ref": "http://json-schema.org/draft-04/schema#"
        }
      ))}
    end

    test "invalid definition schema", %{schema: schema} do
      data = %{"definitions" => %{"foo" => %{"type" => 1}}}
      refute valid?(schema, data)
    end
  end
end
