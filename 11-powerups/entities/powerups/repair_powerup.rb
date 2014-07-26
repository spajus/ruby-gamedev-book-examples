class RepairPowerup < Powerup

  def initialize(object_pool, x, y)
    super
    gfx = PowerupGraphics.new(self)
    gfx.type = :repair
  end

  def on_collision(object)
    if object.class == Tank
      if object.health.health < 100
        object.health.restore
      end
      super
    end
  end

end
