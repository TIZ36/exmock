defmodule Exmock.IMConstants do
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
    end
  end
end
