require 'gosu'

class WorldMap
  attr_accessor :on_screen, :off_screen

  def initialize(width, height)
    @images = {}
    (0..width).step(50) do |x|
      @images[x] = {}
      (0..height).step(50) do |y|
        img = Gosu::Image.from_text(
          $window, "#{x}:#{y}",
          Gosu.default_font_name, 15)
        @images[x][y] = img
      end
    end
  end

  def draw(camera)
    @on_screen = @off_screen = 0
    @images.each do |x, row|
      row.each do |y, val|
        if camera.can_view?(x, y, val)
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
  attr_accessor :x, :y, :zoom

  def initialize
    @x = @y = 0
    @zoom = 1
  end

  def can_view?(x, y, obj)
    x0, x1, y0, y1 = viewport
    (x0 - obj.width..x1).include?(x) &&
      (y0 - obj.height..y1).include?(y)
  end

  def viewport
    x0 = @x - ($window.width / 2)  / @zoom
    x1 = @x + ($window.width / 2)  / @zoom
    y0 = @y - ($window.height / 2) / @zoom
    y1 = @y + ($window.height / 2) / @zoom
    [x0, x1, y0, y1]
  end

  def to_s
    "FPS: #{Gosu.fps}. " <<
      "#{@x}:#{@y} @ #{'%.2f' % @zoom}. " <<
      'WASD to move, arrows to zoom.'
  end

  def draw_crosshair
    $window.draw_line(
      @x - 10, @y, Gosu::Color::YELLOW,
      @x + 10, @y, Gosu::Color::YELLOW, 100)
    $window.draw_line(
      @x, @y - 10, Gosu::Color::YELLOW,
      @x, @y + 10, Gosu::Color::YELLOW, 100)
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

    if button_down?(Gosu::KbUp)
      @camera.zoom -= zoom_delta
    end
    if button_down?(Gosu::KbDown)
      @camera.zoom += zoom_delta
    end
    self.caption = @camera.to_s
  end

  def draw
    off_x = -@camera.x + width / 2
    off_y = -@camera.y + height / 2
    cam_x = @camera.x
    cam_y = @camera.y
    translate(off_x, off_y) do
      @camera.draw_crosshair
      zoom = @camera.zoom
      scale(zoom, zoom, cam_x, cam_y) do
        @map.draw(@camera)
      end
    end
    info = 'Objects on/off screen: ' <<
      "#{@map.on_screen}/#{@map.off_screen}"
    info_img = Gosu::Image.from_text(
      self, info, Gosu.default_font_name, 30)
    info_img.draw(10, 10, 1)
  end
end

GameWindow.new.show
