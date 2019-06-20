defmodule JsonXema.ValidationErrorTest do
  use ExUnit.Case, async: true

  doctest JsonXema.ValidationError

  alias JsonXema.ValidationError
  alias Xema.Validator

  describe "Xema.validate!/2" do
    setup do
      %{schema: ~s|{"type": "integer"}| |> Jason.decode!() |> JsonXema.new()}
    end

    test "returns a ValidationError for invalid data", %{schema: schema} do
      JsonXema.validate!(schema, "foo")
    rescue
      error ->
        assert %ValidationError{} = error
        assert error.message == nil
        assert Exception.message(error) == ~s|Expected "integer", got "foo".|
        assert error.reason == %{type: "integer", value: "foo"}
    end
  end

  describe "format_error/1" do
    setup do
      %{schema: ~s|{"type": "integer"}| |> Jason.decode!() |> JsonXema.new()}
    end

    test "returns a formated error for an error tuple", %{schema: schema} do
      assert schema |> Validator.validate("foo") |> ValidationError.format_error() ==
               ~s|Expected :integer, got \"foo\".|
    end
  end

  describe "exception/1" do
    test "returns unexpected error for unexpected reason" do
      error = ValidationError.exception(reason: "foo")

      assert error == %ValidationError{
               message: nil,
               reason: "foo"
             }

      assert Exception.message(error) == "Unexpected error."
    end

    test "returns unexpected error for internal exception" do
      error = ValidationError.exception(reason: %{items: {}})
      assert Exception.message(error) =~ "got Protocol.UndefinedError with message"
    end
  end
end
