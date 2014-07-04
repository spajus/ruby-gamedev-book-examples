class ObjectPool
  attr_accessor :objects, :map
  def initialize(map)
    @map = map
    @objects = []
  end

  def nearby(object, max_distance)
    result = []
    @objects.each do |obj|
      next if obj == object
      result << obj if Utils.distance_between(
        obj.x, obj.y, object.x, object.y) < max_distance
    end
    result
  end
end
