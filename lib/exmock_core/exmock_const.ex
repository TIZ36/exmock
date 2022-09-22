defmodule Exmock.Const do
  defmacro __using__(_opts) do
    quote do
      alias unquote(__MODULE__)
      import unquote(__MODULE__)

      # resp code
      @resp_code_ok 200
      @resp_code_fail 666

      # im kingdom id
      @kingdom_id_lonia 1
      @kingdom_id_noxus 2
      @kingdom_id_demacia 3
      @kingdom_id_shurima 4
      @kingdom_id_zaun 5
      @kingdom_id_piltover 6
      @kingdom_id_freljord 7

      # im msg_type
      @msg_type_single 2
      @msg_type_group 1
      @msg_type_room 4
      @msg_type_channel 5

      # im group_type
      @group_type_group 1
      @group_type_room 2

      # group change type
      @group_change_type_add 1
      @group_change_type_leave 2
      @group_change_type_create 3

      # blacklist
      @blacked 1
      @no_blacked 0

      # friend
      @op_be_friend 1
      @op_rm_friend 2
    end
  end
end
