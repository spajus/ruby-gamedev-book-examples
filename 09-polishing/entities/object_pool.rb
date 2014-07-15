class ObjectPool
  attr_accessor :objects, :map, :camera

  def initialize
    @objects = []
  end

  def nearby(object, max_distance)
    non_effects.select do |obj|
      obj != object &&
        (obj.x - object.x).abs < max_distance &&
        (obj.y - object.y).abs < max_distance &&
        Utils.distance_between(
          obj.x, obj.y, object.x, object.y) < max_distance
    end
  end

  def non_effects
    @non_effects ||= @objects.reject(&:effect?)
  end

  def new_cycle
    @non_effets = nil
  end
end
