defprotocol Forum.Publishable do
  @fallback_to_any true

  @doc "Returns the topic for the given event"
  def topic(event)
end

defimpl Forum.Publishable, for: Any do
  def topic(%{__struct__: event_module} = event),
    do: event_module.topic(event)
end
