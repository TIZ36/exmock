defmodule Exmock.Struct.FriendReq do
  @moduledoc false
  @derive Jason.Encoder
  defstruct [
    :request_id,
    :from_uid,
    :to_uid,
    :timestamp,
    :ttl,
    request_msg: ""
  ]
end
