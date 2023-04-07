defmodule Maxo.Conf.State do
  @moduledoc false
  defstruct contexts: %{},
            columns: %{},
            tables: %{},
            relations: %{},
            columns_lookup: %{},
            relations_lookup: %{},
            columns_counter: %{}
end
