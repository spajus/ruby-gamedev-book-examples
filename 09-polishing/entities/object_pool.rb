class ObjectPool
  attr_accessor :objects, :map
  def initialize(map)
    @map = map
    @objects = []
  end

  def nearby(object, max_distance)
    @objects.select do |obj|
      obj != object &&
        (obj.x - object.x).abs < max_distance &&
        (obj.y - object.y).abs < max_distance &&
        Utils.distance_between(
          obj.x, obj.y, object.x, object.y) < max_distance
    end
  end
end
