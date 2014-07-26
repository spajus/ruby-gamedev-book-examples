class TankSpeedPowerup < Powerup

  def initialize(object_pool, x, y)
    super
    gfx = PowerupGraphics.new(self)
    gfx.type = :wingman
  end

  def on_collision(object)
    if object.class == Tank
      if object.speed_modifier < 2
        object.speed_modifier += 0.25
      end
      super
    end
  end

end
