defmodule Exmock.Defaults do
  use Exmock.Constants

  def kingdoms() do
    [
      %Kingdom{
        story_id: 1,
        kingdom_id: @kingdom_id_lonia,
        avatar_url: "http://imimg.lilithcdn.com/personal/kingdom/kingdom1.png"
      },
      %Kingdom{
        story_id: 2,
        kingdom_id: @kingdom_id_noxus,
        avatar_url: "http://imimg.lilithcdn.com/personal/kingdom/kingdom1.png"
      },
      %Kingdom{
        story_id: 3,
        kingdom_id: @kingdom_id_demacia,
        avatar_url: "http://imimg.lilithcdn.com/personal/kingdom/kingdom2.png"
      },
      %Kingdom{
        story_id: 4,
        kingdom_id: @kingdom_id_shurima,
        avatar_url: "http://imimg.lilithcdn.com/personal/kingdom/kingdom3.png"
      },
      %Kingdom{
        story_id: 5,
        kingdom_id: @kingdom_id_zaun,
        avatar_url: "http://imimg.lilithcdn.com/personal/kingdom/kingdom4.png"
      },
      %Kingdom{
        story_id: 6,
        kingdom_id: @kingdom_id_piltover,
        avatar_url: "http://imimg.lilithcdn.com/personal/kingdom/kingdom5.png"
      },
      %Kingdom{
        story_id: 7,
        kingdom_id: @kingdom_id_freljord,
        avatar_url: "http://imimg.lilithcdn.com/personal/kingdom/kingdom6.png"
      }
    ]
  end

  def kingdom(id) do
    kingdoms = kingdoms()

    size = length(kingdoms)

    safe_id =
      if id >= size do
        size - 1
      else
        if id < 0 do
          0
        else
          id
        end
      end

    Enum.at(kingdoms, safe_id)
  end
end
