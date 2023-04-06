defmodule Veryapp.DemoTest do
  use Veryapp.DataCase

  alias Veryapp.Demo

  describe "sticks" do
    alias Veryapp.Demo.Stick

    import Veryapp.DemoFixtures

    @invalid_attrs %{name: nil}

    test "list_sticks/0 returns all sticks" do
      stick = stick_fixture()
      assert Demo.list_sticks() == [stick]
    end

    test "get_stick!/1 returns the stick with given id" do
      stick = stick_fixture()
      assert Demo.get_stick!(stick.id) == stick
    end

    test "create_stick/1 with valid data creates a stick" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Stick{} = stick} = Demo.create_stick(valid_attrs)
      assert stick.name == "some name"
    end

    test "create_stick/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Demo.create_stick(@invalid_attrs)
    end

    test "update_stick/2 with valid data updates the stick" do
      stick = stick_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Stick{} = stick} = Demo.update_stick(stick, update_attrs)
      assert stick.name == "some updated name"
    end

    test "update_stick/2 with invalid data returns error changeset" do
      stick = stick_fixture()
      assert {:error, %Ecto.Changeset{}} = Demo.update_stick(stick, @invalid_attrs)
      assert stick == Demo.get_stick!(stick.id)
    end

    test "delete_stick/1 deletes the stick" do
      stick = stick_fixture()
      assert {:ok, %Stick{}} = Demo.delete_stick(stick)
      assert_raise Ecto.NoResultsError, fn -> Demo.get_stick!(stick.id) end
    end

    test "change_stick/1 returns a stick changeset" do
      stick = stick_fixture()
      assert %Ecto.Changeset{} = Demo.change_stick(stick)
    end
  end
end
