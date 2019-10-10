defmodule Forum.SubscribeError do
  defexception [:message, :error]

  @impl true
  def exception(error) do
    %__MODULE__{
      message: "Subscribing failed with error: #{inspect error}",
      error: error
    }
  end
end
