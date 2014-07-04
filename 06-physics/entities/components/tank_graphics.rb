class TankGraphics < Component
  def initialize(game_object)
    super(game_object)
    @body = units.frame('tank1_body.png')
    @shadow = units.frame('tank1_body_shadow.png')
    @gun = units.frame('tank1_dualgun.png')
  end

  def draw(viewport)
    @shadow.draw_rot(x - 1, y - 1, 0, object.direction)
    @body.draw_rot(x, y, 1, object.direction)
    @gun.draw_rot(x, y, 2, object.gun_angle)
    draw_bounding_box if $debug
  end

  def width
    @body.width
  end

  def height
    @body.height
  end

  def draw_bounding_box
    colors = [
      Gosu::Color::RED,
      Gosu::Color::BLUE,
      Gosu::Color::YELLOW,
      Gosu::Color::WHITE
    ]
    i = 0
    object.box.each_slice(2) do |x, y|
      $window.draw_triangle(
        x - 3, y - 3, colors[i],
        x, y, colors[i],
        x + 3 , y - 3, colors[i],
        100)
      i = (i + 1) % 4
    end
  end

  private

  def units
    @@units = Gosu::TexturePacker.load_json(
      $window, Utils.media_path('ground_units.json'), :precise)
  end
end
