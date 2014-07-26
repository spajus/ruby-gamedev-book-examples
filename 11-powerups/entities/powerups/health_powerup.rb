class HealthPowerup < Powerup
  def on_collision(object)
    if object.class == Tank
      object.health.increase(25)
      super
    end
  end

  def graphics
    :life_up
  end
end
