class PlayerInput < Component
  def initialize(camera)
    super(nil)
    @camera = camera
  end

  def control(object)
    set_object(object)
  end

  def update
    d_x, d_y = @camera.target_delta_on_screen
    atan = Math.atan2(($window.width / 2) - d_x - $window.mouse_x,
                      ($window.height / 2) - d_y - $window.mouse_y)
    object.gun_angle = -atan * 180 / Math::PI
    motion_buttons = [Gosu::KbW, Gosu::KbS, Gosu::KbA, Gosu::KbD]

    if any_button_down?(*motion_buttons)
      object.throttle_down = true
      object.direction = change_angle(object.direction, *motion_buttons)
    else
      object.throttle_down = false
    end

    if Game.button_down?(Gosu::MsLeft)
      object.shoot(*@camera.mouse_coords)
    end
  end

  private

  def any_button_down?(*buttons)
    buttons.each do |b|
      return true if Game.button_down?(b)
    end
    false
  end

  def change_angle(previous_angle, up, down, right, left)
    if Game.button_down?(up)
      angle = 0.0
      angle += 45.0 if Game.button_down?(left)
      angle -= 45.0 if Game.button_down?(right)
    elsif Game.button_down?(down)
      angle = 180.0
      angle -= 45.0 if Game.button_down?(left)
      angle += 45.0 if Game.button_down?(right)
    elsif Game.button_down?(left)
      angle = 90.0
      angle += 45.0 if Game.button_down?(up)
      angle -= 45.0 if Game.button_down?(down)
    elsif Game.button_down?(right)
      angle = 270.0
      angle -= 45.0 if Game.button_down?(up)
      angle += 45.0 if Game.button_down?(down)
    end
    angle = (angle + 360) % 360 if angle && angle < 0
    (angle || previous_angle)
  end
end
