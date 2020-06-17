defmodule Forum.TestEventOne do
  use Forum.Event

  @enforce_keys [:life]
  defstruct [:life]

  @type t :: %__MODULE__{
          life: integer()
        }

  @spec new(number | Map.t()) :: __MODULE__.t()
  def new(life) when is_number(life), do: new(%{life: life})
  def new(attrs), do: struct(__MODULE__, attrs)
end
