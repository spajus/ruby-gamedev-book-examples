class BulletSpeedPowerup < Powerup

  def initialize(object_pool, x, y)
    super
    gfx = PowerupGraphics.new(self)
    gfx.type = :straight_gun
  end

  def on_collision(object)
    if object.class == Tank
      if object.bullet_speed_modifier < 3
        object.bullet_speed_modifier += 0.5
      end
      super
    end
  end

end
