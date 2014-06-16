require 'gosu'

class Explosion
  SPRITE = File.join(File.dirname(__FILE__),
                     'media/explosion.png')

  def self.load_animation(window)
    Gosu::Image.load_tiles(window, SPRITE, 128, 128, false)
  end

  def initialize(animation, x, y)
    @animation = animation
    @x = x
    @y = y
    @current_frame = 0
    @delay = 10 #ms
    @last_frame_time = Gosu.milliseconds
  end

  def draw
    if (Gosu.milliseconds - @last_frame_time) > @delay
      @current_frame += 1
      @last_frame_time = Gosu.milliseconds
      @done ||= @current_frame == @animation.size
    end
    return if done?
    img = @animation[@current_frame % @animation.size]
    img.draw(@x - img.width / 2.0,
             @y - img.height / 2.0,
             0)
  end

  def done?
    @done
  end
end

class GameWindow < Gosu::Window
  BACKGROUND = File.join(File.dirname(__FILE__),
                         'media/country_field.png')

  def initialize(width=800, height=600, fullscreen=false)
    super
    self.caption = 'Hello Animation'
    @x = @y = 10
    @animation = Explosion.load_animation(self)
    @background = Gosu::Image.new(self, BACKGROUND, false)
    @explosions = []
    @buttons_down = 0
  end

  def update
    @explosions.reject!(&:done?)
  end

  def button_down(id)
    close if id == Gosu::KbEscape
    if id == Gosu::MsLeft
      @explosions.push Explosion.new(@animation, mouse_x, mouse_y)
    end
  end

  def needs_cursor?
    true
  end

  def needs_redraw?
    !@scene_ready || @explosions.any?
  end

  def draw
    @scene_ready ||= true
    @background.draw(0, 0, 0)
    @explosions.map(&:draw)
  end
end

window = GameWindow.new
window.show
