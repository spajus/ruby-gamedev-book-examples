class RepairPowerup < Powerup
  def on_collision(object)
    if object.class == Tank
      if object.health.health < 100
        object.health.restore
      end
      super
    end
  end

  def graphics
    :repair
  end
end
