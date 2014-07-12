require 'gosu_texture_packer'
class BoxGraphics < Component
  DEBUG_COLORS = [
    Gosu::Color::RED,
    Gosu::Color::BLUE,
    Gosu::Color::YELLOW,
    Gosu::Color::WHITE
  ]

  def initialize(object)
    super(object)
    load_sprite
  end

  def draw(viewport)
    #x1, x2, y1, y2 = viewport
    #if (x1 - width..x2 + width).include?(center_x)
    #  if (y1 - height..y2 + height).include?(center_y)
    @box.draw_rot(x, y, 0, object.angle)
    #  end
    #end
    if $debug
      i = 0
      object.box.each_slice(2) do |x, y|
        color = DEBUG_COLORS[i]
        i += 1
        $window.draw_triangle(
          x - 5, y, color,
          x, y + 5, color,
          x, y, color,
          1000)
      end
    end
  end

  def height
    @box.height
  end

  def width
    @box.width
  end

  private

  def load_sprite
    frame = boxes.frame_list.sample
    @box = boxes.frame(frame)
  end

  def center_x
    @center_x ||= x - width / 2
  end

  def center_y
    @center_y ||= y - height / 2
  end

  def boxes
    @@boxes ||= Gosu::TexturePacker.load_json($window,
      Utils.media_path('boxes_barrels.json'))
  end
end
