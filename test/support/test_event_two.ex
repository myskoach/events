defmodule Forum.TestEventTwo do
  use Forum.Event

  @enforce_keys [:question]
  defstruct [:question]

  @type t :: %__MODULE__{
          question: String.t()
        }

  @spec new(String.t() | Map.t()) :: __MODULE__.t()
  def new(question) when is_binary(question), do: new(%{question: question})
  def new(attrs), do: struct(__MODULE__, attrs)
end
