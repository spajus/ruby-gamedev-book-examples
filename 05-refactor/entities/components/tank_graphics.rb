class TankGraphics < Component
  attr_accessor :object

  def initialize(game_object)
    super(game_object)
    @body = units.frame('tank1_body.png')
    @shadow = units.frame('tank1_body_shadow.png')
    @gun = units.frame('tank1_dualgun.png')
  end

  def draw(viewport)
    @shadow.draw_rot(object.x - 1, object.y - 1, 0, object.direction)
    @body.draw_rot(object.x, object.y, 1, object.direction)
    @gun.draw_rot(object.x, object.y, 2, object.gun_angle)
  end

  private

  def units
    @@units = Gosu::TexturePacker.load_json(
      $window, Game.media_path('ground_units.json'), :precise)
  end
end
