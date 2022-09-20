defmodule Exmock.Struct.FriendReq do
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