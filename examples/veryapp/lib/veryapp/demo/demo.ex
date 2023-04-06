defmodule Veryapp.Demo do
  @moduledoc """
  The Demo context.
  """

  import Ecto.Query, warn: false
  alias Veryapp.Repo

  alias Veryapp.Demo.Stick

  @doc """
  Returns the list of sticks.

  ## Examples

      iex> list_sticks()
      [%Stick{}, ...]

  """
  def list_sticks do
    Repo.all(Stick)
  end

  @doc """
  Gets a single stick.

  Raises `Ecto.NoResultsError` if the Stick does not exist.

  ## Examples

      iex> get_stick!(123)
      %Stick{}

      iex> get_stick!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stick!(id), do: Repo.get!(Stick, id)

  @doc """
  Creates a stick.

  ## Examples

      iex> create_stick(%{field: value})
      {:ok, %Stick{}}

      iex> create_stick(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stick(attrs \\ %{}) do
    %Stick{}
    |> Stick.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a stick.

  ## Examples

      iex> update_stick(stick, %{field: new_value})
      {:ok, %Stick{}}

      iex> update_stick(stick, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stick(%Stick{} = stick, attrs) do
    stick
    |> Stick.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a stick.

  ## Examples

      iex> delete_stick(stick)
      {:ok, %Stick{}}

      iex> delete_stick(stick)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stick(%Stick{} = stick) do
    Repo.delete(stick)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stick changes.

  ## Examples

      iex> change_stick(stick)
      %Ecto.Changeset{data: %Stick{}}

  """
  def change_stick(%Stick{} = stick, attrs \\ %{}) do
    Stick.changeset(stick, attrs)
  end
end
