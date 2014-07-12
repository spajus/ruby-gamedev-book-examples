require 'gosu_texture_packer'
class TreeGraphics < Component

  def initialize(object, seed)
    super(object)
    load_sprite(seed)
  end

  def draw(viewport)
    #x1, x2, y1, y2 = viewport
    #if (x1 - width..x2 + width).include?(center_x)
    #  if (y1 - height..y2 + height).include?(center_y)
        @tree.draw(center_x, center_y, 5)
    #  end
    #end
    if $debug
      color = Gosu::Color::RED
      $window.draw_triangle(
        x - 5, y, color,
        x, y + 5, color,
        x, y, color,
        1000)
    end
  end

  def height
    @tree.height
  end

  def width
    @tree.width
  end

  private

  def load_sprite(seed)
    frame_list = trees.frame_list
    frame = frame_list[(frame_list.size * seed).round]
    @tree = trees.frame(frame)
  end

  def center_x
    @center_x ||= x - @tree.width / 2
  end

  def center_y
    @center_y ||= y - @tree.height / 2
  end

  def trees
    @@trees ||= Gosu::TexturePacker.load_json($window,
      Utils.media_path('trees_packed.json'))
  end
end
