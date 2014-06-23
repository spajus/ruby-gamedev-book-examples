require 'gosu'
require 'gosu_tiled'
require 'gosu_texture_packer'

class Tank
  attr_accessor :x, :y, :body_angle, :gun_angle

  def initialize(window, body, shadow, gun)
    @x = window.width / 2
    @y = window.height / 2
    @window = window
    @body = body
    @shadow = shadow
    @gun = gun
    @body_angle = 0.0
    @gun_angle = 0.0
  end

  def update
    atan = Math.atan2(320 - @window.mouse_x,
                      240 - @window.mouse_y)
    @gun_angle = -atan * 180 / Math::PI
    @body_angle = change_angle(@body_angle,
      Gosu::KbW, Gosu::KbS, Gosu::KbA, Gosu::KbD)
  end

  def draw
    @shadow.draw_rot(@x - 1, @y - 1, 0, @body_angle)
    @body.draw_rot(@x, @y, 1, @body_angle)
    @gun.draw_rot(@x, @y, 2, @gun_angle)
  end

  private

  def change_angle(previous_angle, up, down, right, left)
    if @window.button_down?(up)
      angle = 0.0
      angle += 45.0 if @window.button_down?(left)
      angle -= 45.0 if @window.button_down?(right)
    elsif @window.button_down?(down)
      angle = 180.0
      angle -= 45.0 if @window.button_down?(left)
      angle += 45.0 if @window.button_down?(right)
    elsif @window.button_down?(left)
      angle = 90.0
      angle += 45.0 if @window.button_down?(up)
      angle -= 45.0 if @window.button_down?(down)
    elsif @window.button_down?(right)
      angle = 270.0
      angle -= 45.0 if @window.button_down?(up)
      angle += 45.0 if @window.button_down?(down)
    end
    angle || previous_angle
  end
end

class GameWindow < Gosu::Window
  MAP_FILE = File.join(File.dirname(__FILE__), 'island.json')
  UNIT_FILE = File.join(File.dirname(__FILE__),
                        'media', 'ground_units.json')
  SPEED = 5

  def initialize
    super(640, 480, false)
    @map = Gosu::Tiled.load_json(self, MAP_FILE)
    @units = Gosu::TexturePacker.load_json(
      self, UNIT_FILE, :precise)
    @tank = Tank.new(self,
      @units.frame('tank1_body.png'),
      @units.frame('tank1_body_shadow.png'),
      @units.frame('tank1_dualgun.png'))
    @x = @y = 0
    @first_render = true
    @buttons_down = 0
  end

  def needs_cursor?
    true
  end

  def button_down(id)
    close if id == Gosu::KbEscape
    @buttons_down += 1
  end

  def button_up(id)
    @buttons_down -= 1
  end

  def update
    @x -= SPEED if button_down?(Gosu::KbA)
    @x += SPEED if button_down?(Gosu::KbD)
    @y -= SPEED if button_down?(Gosu::KbW)
    @y += SPEED if button_down?(Gosu::KbS)
    @tank.update
    self.caption = "#{Gosu.fps} FPS. Use WASD and mouse to control tank"
  end

  def draw
    @first_render = false
    @map.draw(@x, @y)
    @tank.draw()
  end
end

GameWindow.new.show
