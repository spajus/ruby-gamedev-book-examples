class Explosion
  FRAME_DELAY = 16.66 # ms

  def animation
    @@animation ||=
    Gosu::Image.load_tiles(
      $window, Game.media_path('explosion.png'), 128, 128, false)
  end

  def sound
    @@sound ||= Gosu::Sample.new(
      $window, Game.media_path('explosion.ogg'))
  end

  def initialize(x, y)
    sound.play if sound
    @x, @y = x, y
    @current_frame = 0
  end

  def update
    advance_frame
  end

  def draw
    return if done?
    image = current_frame
    image.draw(
      @x - image.width / 2 + 3,
      @y - image.height / 2 - 35,
      20)
  end

  def done?
    @done ||= @current_frame >= animation.size
  end

  private

  def current_frame
    animation[@current_frame % animation.size]
  end

  def advance_frame
    now = Gosu.milliseconds
    delta = now - (@last_frame ||= now)
    if delta > FRAME_DELAY
      @last_frame = now
    end
    @current_frame += (delta / FRAME_DELAY).floor
  end
end
