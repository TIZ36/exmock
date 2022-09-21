defprotocol ToStringProtocol do
  def to(v)
end

defimpl ToStringProtocol, for: Integer do
  def to(v), do: to_string(v)
end
defimpl ToStringProtocol, for: BitString do
  def to(v), do: v
end
defimpl ToStringProtocol, for: List do
  def to(v), do: List.to_charlist(v) |> to_string()
end
defimpl ToStringProtocol, for: Any do
  def to(_v), do: throw({:fail, :unsupport_trans})
end
