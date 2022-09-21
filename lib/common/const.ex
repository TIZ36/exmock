defmodule Exmock.Constants do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      @kingdom_id_lonia 1
      @kingdom_id_noxus 2
      @kingdom_id_demacia 3
      @kingdom_id_shurima 4
      @kingdom_id_zaun 5
      @kingdom_id_piltover 6
      @kingdom_id_freljord 7

      @msg_type_single 2
      @msg_type_group 1
      @msg_type_room 4
      @msg_type_channel 5

      @group_type_group 1
      @group_type_room 2


      @blacked 1
      @no_blacked 0

      @group_change_type_add 1
      @group_change_type_leave 2
      @group_change_type_create 3

      @op_be_friend 1
      @op_rm_friend 2
    end
  end
end
