class AiVision
  attr_reader :in_sight
  def initialize(viewer, object_pool, distance)
    @viewer = viewer
    @object_pool = object_pool
    @distance = distance
  end

  def update
    @in_sight = @object_pool.nearby(@viewer, @distance)
  end

  def closest_tank
    @in_sight.sort do |a, b|
      d1 = Utils.distance_between(@viewer.x, @viewer.y, a.x, a.y)
      d2 = Utils.distance_between(@viewer.x, @viewer.y, b.x, b.y)
      d1 <=> d2
    end.first
  end
end
