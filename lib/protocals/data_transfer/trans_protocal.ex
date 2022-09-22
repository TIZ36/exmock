defprotocol DataType.TransProtocol do
  @spec trans_in(t) :: Any.t()
  def trans_in(value)

  @spec trans_out(t) :: Any.t()
  def trans_out(value)
end
