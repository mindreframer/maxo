ExUnit.start()

defmodule MnemeDefauls do
  defmacro __using__(_) do
    quote do
      use Mneme, action: :accept, default_pattern: :last, force_update: true
    end
  end
end
