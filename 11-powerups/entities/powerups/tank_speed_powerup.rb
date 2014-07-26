class TankSpeedPowerup < Powerup
  def on_collision(object)
    if object.class == Tank
      if object.speed_modifier < 2
        object.speed_modifier += 0.25
      end
      super
    end
  end

  def graphics
    :wingman
  end
end
