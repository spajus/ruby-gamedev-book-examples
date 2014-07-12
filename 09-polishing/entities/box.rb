class Box < GameObject
  attr_reader :x, :y, :health, :graphics, :angle

  def initialize(object_pool, x, y)
    super(object_pool)
    @x, @y = x, y
    @graphics = BoxGraphics.new(self)
    @health = Health.new(self, object_pool, 10, true)
    @angle = rand(-15..15)
  end

  def on_collision(object)
    @x, @y = Utils.point_at_distance(@x, @y, object.direction, 2)
    @box = nil
  end

  def box
    return @box if @box
    w = @graphics.width / 2
    h = @graphics.height / 2
    @box = [x - w + 4,     y - h + 8,
            x + w , y - h + 8,
            x + w , y + h,
            x - w + 4,     y + h]
    @box = Utils.rotate(@angle, @x, @y, *@box)
  end
end
