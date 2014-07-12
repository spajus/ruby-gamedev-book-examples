class Tree < GameObject
  attr_reader :x, :y, :health, :graphics

  def initialize(object_pool, x, y, seed)
    super(object_pool)
    @x, @y = x, y
    @graphics = TreeGraphics.new(self, seed)
    @health = Health.new(self, object_pool, 30, false)
  end

  def box
    [x, y]
  end
end
