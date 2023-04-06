defmodule Veryapp.DemoFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Veryapp.Demo` context.
  """

  @doc """
  Generate a stick.
  """
  def stick_fixture(attrs \\ %{}) do
    {:ok, stick} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Veryapp.Demo.create_stick()

    stick
  end
end
