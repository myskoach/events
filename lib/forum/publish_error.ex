defmodule Forum.PublishError do
  defexception [:message, :error]

  @impl true
  def exception(error) do
    %__MODULE__{
      message: "Publishing failed with error: #{inspect error}",
      error: error
    }
  end
end
