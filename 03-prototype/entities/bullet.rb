class Bullet
  COLOR = Gosu::Color::BLACK
  MAX_DIST = 300
  MIN_DIST = 100
  START_DIST = 20
  def initialize(source_x, source_y, target_x, target_y)
    @x, @y = source_x, source_y
    @target_x, @target_y = target_x, target_y
    @x, @y = point_at_distance(START_DIST)
    if trajectory_length > MAX_DIST
      @target_x, @target_y = point_at_distance(MAX_DIST)
    end
    if trajectory_length < MIN_DIST
      @target_x, @target_y = point_at_distance(MIN_DIST)
    end
    sound.play
    @fired_at = Gosu.milliseconds
  end

  def draw
    unless arrived?
      $window.draw_quad(@x - 2, @y - 2, COLOR,
                        @x + 2, @y - 2, COLOR,
                        @x - 2, @y + 2, COLOR,
                        @x + 2, @y + 2, COLOR,
                        1)
    else
      @explosion ||= Explosion.new(@x, @y)
      @explosion.draw
    end
  end

  def sound
    @@sound ||= Gosu::Sample.new(
      $window, Game.media_path('fire.mp3'))
  end

  def update
    fly_distance = (Gosu.milliseconds - @fired_at) * 0.001 * @speed
    @x, @y = point_at_distance(fly_distance)
    @explosion && @explosion.update
  end

  def arrived?
    @x == @target_x && @y == @target_y
  end

  def done?
     exploaded?
  end

  def exploaded?
    @explosion && @explosion.done?
  end

  def fire(speed)
    @speed = speed
    self
  end

  def trajectory_length
    d_x = @target_x - @x
    d_y = @target_y - @y
    Math.sqrt(d_x * d_x + d_y * d_y)
  end

  def point_at_distance(distance)
    return [@target_x, @target_y] if distance > trajectory_length
    distance_factor = distance.to_f / trajectory_length
    p_x = @x + (@target_x - @x) * distance_factor
    p_y = @y + (@target_y - @y) * distance_factor
    [p_x, p_y]
  end

  private

end
