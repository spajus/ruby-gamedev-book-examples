class BulletSpeedPowerup < Powerup
  def on_collision(object)
    if object.class == Tank
      if object.bullet_speed_modifier < 2
        object.bullet_speed_modifier += 0.25
      end
      super
    end
  end

  def graphics
    :straight_gun
  end
end
