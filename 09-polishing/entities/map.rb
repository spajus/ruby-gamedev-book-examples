require 'perlin_noise'
require 'gosu_texture_packer'
require 'gosu_tiled'

class Map
  MAP_WIDTH = 30
  MAP_HEIGHT = 30
  TILE_SIZE = 128

  def initialize
    load_tiles
    @map = generate_map
    @tree_map = generate_trees
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

  def movement_penalty(x, y)
    tile = tile_at(x, y)
    case tile
    when @sand
      0.33
    else
      0
    end
  end

  def draw(viewport)
    viewport.map! { |p| p / TILE_SIZE }
    x0, x1, y0, y1 = viewport.map(&:to_i)
    (x0-1..x1).each do |x|
      (y0-1..y1).each do |y|
        row = @map[x]
        map_x = x * TILE_SIZE
        map_y = y * TILE_SIZE
        if row
          tile = @map[x][y]
          if tile
            tile.draw(map_x, map_y, 0)
          else
            @water.draw(map_x, map_y, 0)
          end
        else
          @water.draw(map_x, map_y, 0)
        end
        draw_tree(x, y)
      end
    end
  end

  private

  def draw_tree(tile_x, tile_y)
    return unless @tree_map[tile_x] && @tree_map[tile_x][tile_y]
    x, y, c_x, c_y, tree = @tree_map[tile_x][tile_y]
    @trees.frame(tree).draw(x, y, 5)
    color = Gosu::Color::RED
    if $debug
      $window.draw_triangle(
        c_x - 5, c_y, color,
        c_x, c_y + 5, color,
        c_x, c_y, color,
        1000)
    end
  end

  def tile_at(x, y)
    t_x = ((x / TILE_SIZE) % TILE_SIZE).floor
    t_y = ((y / TILE_SIZE) % TILE_SIZE).floor
    row = @map[t_x]
    row ? row[t_y] : @water
  end

  def load_tiles
    tiles = Gosu::Image.load_tiles(
      $window, Utils.media_path('ground.png'),
      128, 128, true)
    @sand = tiles[0]
    @grass = tiles[8]
    @water = Gosu::Image.new(
      $window, Utils.media_path('water.png'), true)
    @trees = Gosu::TexturePacker.load_json($window,
      Utils.media_path('trees_packed.json'))
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

  def generate_trees
    noises = Perlin::Noise.new(2)
    contrast = Perlin::Curve.contrast(
      Perlin::Curve::CUBIC, 2)
    tree_map = {}
    rand(30000).times do |t|
      x = rand(0..MAP_WIDTH * TILE_SIZE)
      y = rand(0..MAP_HEIGHT * TILE_SIZE)
      n = noises[x * 0.001, y * 0.001]
      n = contrast.call(n)
      t_x = x / TILE_SIZE
      t_y = y / TILE_SIZE
      frame = @trees.frame_list[(@trees.frame_list.size * n).round]
      c_x = x + @trees.frame(frame).width / 2
      c_y = y + @trees.frame(frame).height / 2
      if tile_at(c_x, c_y) == @grass && n > 0.5
        tree_map[t_x] ||= {}
        tree_map[t_x][t_y] = [x, y, c_x, c_y, frame]
      end
    end
    tree_map
  end

  def choose_tile(val)
    case val
    when 0.0..0.3 # 30% chance
      @water
    when 0.3..0.5 # 20% chance, water edges
      @sand
    else # 50% chance
      @grass
    end
  end
end
