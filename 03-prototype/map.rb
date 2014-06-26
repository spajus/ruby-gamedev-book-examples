require 'perlin_noise'
require 'gosu_texture_packer'
class Map
  MAP_WIDTH = 100
  MAP_HEIGHT = 100
  TILE_SIZE = 128

  def initialize
    load_tiles
    @map = generate_map
  end

  def find_spawn_point
    while true
      x = rand(0..MAP_WIDTH * TILE_SIZE)
      y = rand(0..MAP_HEIGHT * TILE_SIZE)
      if can_move_to?(x, y)
        return [x, y]
      else
        puts "Invalid spawn point: #{[x, y]}"
      end
    end
  end

  def can_move_to?(x, y)
    tile = tile_at(x, y)
    tile && tile != @water
  end

  def draw(camera)
    @map.each do |x, row|
      row.each do |y, val|
        tile = @map[x][y]
        map_x = x * TILE_SIZE
        map_y = y * TILE_SIZE
        if camera.can_view?(map_x, map_y, tile)
          tile.draw(map_x, map_y, 0)
        end
      end
    end
  end

  private

  def tile_at(x, y)
    t_x = ((x / TILE_SIZE) % TILE_SIZE).floor
    t_y = ((y / TILE_SIZE) % TILE_SIZE).floor
    row = @map[t_x]
    row[t_y] if row
  end

  def load_tiles
    tiles = Gosu::Image.load_tiles(
      $window, Game.media_path('ground.png'), 128, 128, true)
    @sand = tiles[0]
    @grass = tiles[8]
    @water = Gosu::Image.new(
      $window, Game.media_path('water.png'), true)
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
