class BulletSpeedPowerup < Powerup
  def pickup(object)
    if object.class == Tank
      if object.bullet_speed_modifier < 2
        object.bullet_speed_modifier += 0.25
      end
      true
    end
  end

  def graphics
    :straight_gun
  end
end
