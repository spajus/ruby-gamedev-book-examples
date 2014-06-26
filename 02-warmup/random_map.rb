require 'gosu'
require 'gosu_texture_packer'

def media_path(file)
  File.join(File.dirname(File.dirname(
    __FILE__)), 'media', file)
end

class GameWindow < Gosu::Window
  WIDTH = 800
  HEIGHT = 600
  TILE_SIZE = 128

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = 'Random Map'
    @tileset = Gosu::TexturePacker.load_json(
      self, media_path('ground.json'), :precise)
    @redraw = true
  end

  def button_down(id)
    close if id == Gosu::KbEscape
    @redraw = true if id == Gosu::KbSpace
  end

  def needs_redraw?
    @redraw
  end

  def draw
    @redraw = false
    (0..WIDTH / TILE_SIZE).each do |x|
      (0..HEIGHT / TILE_SIZE).each do |y|
        @tileset.frame(
          @tileset.frame_list.sample).draw(
            x * (TILE_SIZE),
            y * (TILE_SIZE),
            0)
      end
    end
  end
end

window = GameWindow.new
window.show
