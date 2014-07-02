class Tank
  attr_accessor :x, :y, :body_angle, :gun_angle
  SHOOT_DELAY = 500

  def initialize(map)
    @map = map
    @units = Gosu::TexturePacker.load_json(
      $window, Game.media_path('ground_units.json'), :precise)
    @body = @units.frame('tank1_body.png')
    @shadow = @units.frame('tank1_body_shadow.png')
    @gun = @units.frame('tank1_dualgun.png')
    @x, @y = @map.find_spawn_point
    @body_angle = 0.0
    @gun_angle = 0.0
    @last_shot = 0
    sound.volume = 0.3
  end

  def sound
    @@sound ||= Gosu::Song.new(
      $window, Game.media_path('tank_driving.mp3'))
  end

  def shoot(target_x, target_y)
    if Gosu.milliseconds - @last_shot > SHOOT_DELAY
      @last_shot = Gosu.milliseconds
      Bullet.new(@x, @y, target_x, target_y).fire(100)
    end
  end

  def update(camera)
    d_x, d_y = camera.target_delta_on_screen
    atan = Math.atan2(($window.width / 2) - d_x - $window.mouse_x,
                      ($window.height / 2) - d_y - $window.mouse_y)
    @gun_angle = -atan * 180 / Math::PI
    new_x, new_y = @x, @y
    new_x -= speed if $window.button_down?(Gosu::KbA)
    new_x += speed if $window.button_down?(Gosu::KbD)
    new_y -= speed if $window.button_down?(Gosu::KbW)
    new_y += speed if $window.button_down?(Gosu::KbS)
    if @map.can_move_to?(new_x, new_y)
      @x, @y = new_x, new_y
    else
      @speed = 1.0
    end
    @body_angle = change_angle(@body_angle,
      Gosu::KbW, Gosu::KbS, Gosu::KbA, Gosu::KbD)

    if moving?
      sound.play(true)
    else
      sound.pause
    end

    if $window.button_down?(Gosu::MsLeft)
      shoot(*camera.mouse_coords)
    end
  end

  def moving?
    any_button_down?(Gosu::KbA, Gosu::KbD, Gosu::KbW, Gosu::KbS)
  end

  def draw
    @shadow.draw_rot(@x - 1, @y - 1, 0, @body_angle)
    @body.draw_rot(@x, @y, 1, @body_angle)
    @gun.draw_rot(@x, @y, 2, @gun_angle)
  end

  def speed
    @speed ||= 1.0
    if moving?
      @speed += 0.03 if @speed < 5
    else
      @speed = 1.0
    end
    @speed
  end

  private

  def any_button_down?(*buttons)
    buttons.each do |b|
      return true if $window.button_down?(b)
    end
    false
  end

  def change_angle(previous_angle, up, down, right, left)
    if $window.button_down?(up)
      angle = 0.0
      angle += 45.0 if $window.button_down?(left)
      angle -= 45.0 if $window.button_down?(right)
    elsif $window.button_down?(down)
      angle = 180.0
      angle -= 45.0 if $window.button_down?(left)
      angle += 45.0 if $window.button_down?(right)
    elsif $window.button_down?(left)
      angle = 90.0
      angle += 45.0 if $window.button_down?(up)
      angle -= 45.0 if $window.button_down?(down)
    elsif $window.button_down?(right)
      angle = 270.0
      angle -= 45.0 if $window.button_down?(up)
      angle += 45.0 if $window.button_down?(down)
    end
    angle || previous_angle
  end
end
