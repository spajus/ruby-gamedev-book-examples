class Explosion
  FRAME_DELAY = 10 # ms

  def animation
    @@animation ||=
    Gosu::Image.load_tiles(
      $window, Game.media_path('explosion.png'), 128, 128, false)
  end

  def sound
    @@sound ||= Gosu::Sample.new(
      $window, Game.media_path('explosion.mp3'))
  end

  def initialize(x, y)
    sound.play
    @x, @y = x, y
    @current_frame = 0
  end

  def update
    @current_frame += 1 if frame_expired?
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
    @done ||= @current_frame == animation.size
  end

  private

  def current_frame
    animation[@current_frame % animation.size]
  end

  def frame_expired?
    now = Gosu.milliseconds
    @last_frame ||= now
    if (now - @last_frame) > FRAME_DELAY
      @last_frame = now
    end
  end
end
