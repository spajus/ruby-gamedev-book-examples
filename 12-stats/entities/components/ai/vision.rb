class AiVision
  CACHE_TIMEOUT = 500
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
    now = Gosu.milliseconds
    @closest_tank = nil
    if now - (@cache_updated_at ||= 0) > CACHE_TIMEOUT
      @closest_tank = nil
      @cache_updated_at = now
    end
    @closest_tank ||= find_closest_tank
  end

  private

  def find_closest_tank
    @in_sight.select do |o|
      o.class == Tank && !o.health.dead?
    end.sort do |a, b|
      x, y = @viewer.x, @viewer.y
      d1 = Utils.distance_between(x, y, a.x, a.y)
      d2 = Utils.distance_between(x, y, b.x, b.y)
      d1 <=> d2
    end.first
  end
end
