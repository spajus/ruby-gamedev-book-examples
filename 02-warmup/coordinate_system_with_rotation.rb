require 'gosu'

class WorldMap
  attr_accessor :on_screen, :off_screen
  def initialize(width, height)
    @images = {}
    (0..width).step(50) do |x|
      @images[x] = {}
      (0..height).step(50) do |y|
        @images[x][y] = Gosu::Image.from_text($window, "#{x}:#{y}", Gosu.default_font_name, 15)
      end
    end
  end

  def draw(camera)
    @on_screen = @off_screen = 0
    @images.each do |x, row|
      row.each do |y, val|
        if camera.can_view?(x, y, val.width, val.height)
          val.draw(x, y, 0)
          @on_screen += 1
        else
          @off_screen += 1
        end
      end
    end
  end
end

class Camera
  attr_accessor :x, :y, :angle, :zoom
  def initialize
    @x = 0
    @y = 0
    @angle = 0.0
    @zoom = 1
  end

  def can_view?(x, y, obj_width, obj_height)
    x0, x1, y0, y1 = viewport
    (x0-obj_width..x1).include?(x) && (y0-obj_height..y1).include?(y)
  end

  def viewport
    x0 = @x-($window.width/2)/@zoom
    x1 = @x+($window.width/2)/@zoom
    y0 = @y-($window.height/2)/@zoom
    y1 = @y+($window.height/2)/@zoom
    unless @angle < 1 || (@angle < 181 && @angle > 179)
      radius = Math.sqrt(($window.height * $window.height) + ($window.width * $window.width))
      x0 = @x - (radius/2) / @zoom
      x1 = @x + (radius/2) / @zoom
      y0 = @y - (radius/2) / @zoom
      y1 = @y + (radius/2) / @zoom
    end
    [x0, x1, y0, y1]
  end

  def to_s
    "FPS: #{Gosu.fps}. #{@x}:#{@y} @ #{'%.2f' % @zoom} / #{'%.2f' % @angle} deg"
  end

  def draw_crosshair
    $window.draw_line(@x - 10, @y, Gosu::Color::RED,
                      @x + 10, @y, Gosu::Color::RED, 100)
    $window.draw_line(@x, @y - 10, Gosu::Color::RED,
                      @x, @y + 10, Gosu::Color::RED, 100)
  end

  private

  def apply_angle(x, y)
    dx = (x * Math.cos(@angle)) - (y * Math.sin(@angle))
    dy = (y * Math.cos(@angle)) + (x * Math.sin(@angle))
    [x, y]
    [dx, dy]
  end
end


class GameWindow < Gosu::Window
  SPEED = 10
  def initialize
    super(800, 600, false)
    $window = self
    @map = WorldMap.new(2048, 1024)
    @camera = Camera.new
  end

  def button_down(id)
    close if id == Gosu::KbEscape
    if id == Gosu::KbSpace
      @camera.angle = 0.0
      @camera.zoom = 1.0
      @camera.x = 0
      @camera.y = 0
    end
  end

  def update
    @camera.x -= SPEED if button_down?(Gosu::KbA)
    @camera.x += SPEED if button_down?(Gosu::KbD)
    @camera.y -= SPEED if button_down?(Gosu::KbW)
    @camera.y += SPEED if button_down?(Gosu::KbS)
    zoom_delta = @camera.zoom > 0 ? 0.01 : 1.0
    @camera.zoom -= zoom_delta if button_down?(Gosu::KbUp)
    @camera.zoom += zoom_delta if button_down?(Gosu::KbDown)
    if button_down?(Gosu::KbLeft)
      @camera.angle = (360 + @camera.angle - 2) % 360
    end
    if button_down?(Gosu::KbRight)
      @camera.angle = (@camera.angle + 2) % 360
    end
    self.caption = @camera.to_s
  end

  def draw
    translate(-@camera.x+width/2, -@camera.y+height/2) do
      @camera.draw_crosshair
      rotate(@camera.angle, @camera.x, @camera.y) do
        scale(@camera.zoom, @camera.zoom, @camera.x, @camera.y) do
          @map.draw(@camera)
       end
      end
    end
    Gosu::Image.from_text(self, "Objects on/off screen: #{@map.on_screen}/#{@map.off_screen}", Gosu.default_font_name, 30).draw(10, 10, 1)
  end
end

GameWindow.new.show
