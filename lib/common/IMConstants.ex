defmodule Exmock.IMConstants do
  defmacro __using__(_opts) do
    quote do

      @msg_type_single 2
      @msg_type_group 1
      @msg_type_room 4
      @msg_type_channel 5
    end
  end
end