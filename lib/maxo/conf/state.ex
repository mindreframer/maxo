defmodule Maxo.Conf.State do
  @moduledoc false
  defstruct contexts: %{},
            columns: %{},
            tables: %{},
            indexes: %{},
            relations: %{},
            private: %{
              columns_lookup: %{},
              relations_lookup: %{},
              indexes_lookup: %{},
              columns_counter: %{}
            }
end
