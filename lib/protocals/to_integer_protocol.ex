defprotocol ToIntegerProtocol do
  def to(v)
end

defimpl ToIntegerProtocol, for: Integer do
  def to(v), do: v
end
defimpl ToIntegerProtocol, for: BitString do
  def to(v) do
    {v_int, _} = Integer.parse(v)
    v_int
  end
end
defimpl ToIntegerProtocol, for: Any do
  def to(v), do: throw({:fail, :unsupport_trans})
end