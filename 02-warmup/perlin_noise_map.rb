require 'gosu'
require 'gosu_texture_packer'
require 'perlin_noise'

def media_path(file)
  File.join(File.dirname(File.dirname(
    __FILE__)), 'media', file)
end

class GameWindow < Gosu::Window
  MAP_WIDTH = 100
  MAP_HEIGHT = 100
  WIDTH = 800
  HEIGHT = 600
  TILE_SIZE = 128

  def initialize
    super(WIDTH, HEIGHT, false)
    load_tiles
    @map = generate_map
    @zoom = 0.2
  end

  def button_down(id)
    close if id == Gosu::KbEscape
    @map = generate_map if id == Gosu::KbSpace
  end

  def update
    adjust_zoom(0.005) if button_down?(Gosu::KbDown)
    adjust_zoom(-0.005) if button_down?(Gosu::KbUp)
    set_caption
  end

  def draw
    tiles_x.times do |x|
      tiles_y.times do |y|
        @map[x][y].draw(
          x * TILE_SIZE * @zoom,
          y * TILE_SIZE * @zoom,
          0,
          @zoom,
          @zoom)
      end
    end
  end

  private

  def set_caption
    self.caption = 'Perlin Noise. ' <<
      "Zoom: #{'%.2f' % @zoom}. " <<
      'Use Up/Down to zoom. Space to regenerate.'
  end

  def adjust_zoom(delta)
    new_zoom = @zoom + delta
    if new_zoom > 0.07 && new_zoom < 2
      @zoom = new_zoom
    end
  end

  def load_tiles
    tiles = Gosu::Image.load_tiles(
      self, media_path('ground.png'), 128, 128, true)
    @sand = tiles[0]
    @grass = tiles[8]
    @water = Gosu::Image.new(
      self, media_path('water.png'), true)
  end

  def tiles_x
    count = (WIDTH / (TILE_SIZE * @zoom)).ceil + 1
    [count, MAP_WIDTH].min
  end

  def tiles_y
    count = (HEIGHT / (TILE_SIZE * @zoom)).ceil + 1
    [count, MAP_HEIGHT].min
  end

  def generate_map
    noises = Perlin::Noise.new(2)
    contrast = Perlin::Curve.contrast(
      Perlin::Curve::CUBIC, 2)
    map = {}
    MAP_WIDTH.times do |x|
      map[x] = {}
      MAP_HEIGHT.times do |y|
        n = noises[x * 0.1, y * 0.1]
        n = contrast.call(n)
        map[x][y] = choose_tile(n)
      end
    end
    map
  end

  def choose_tile(val)
    case val
    when 0.0..0.3 # 30% chance
      @water
    when 0.3..0.45 # 15% chance, water edges
      @sand
    else # 55% chance
      @grass
    end
  end

end

window = GameWindow.new
window.show
