class AiVision
  CACHE_TIMEOUT = 500
  POWERUP_CACHE_TIMEOUT = 50
  attr_reader :in_sight

  def initialize(viewer, object_pool, distance)
    @viewer = viewer
    @object_pool = object_pool
    @distance = distance
  end

  def can_go_forward?
    in_front = Utils.point_at_distance(
      *@viewer.location, @viewer.direction, 20)
    @object_pool.map.can_move_to?(*in_front) &&
      @object_pool.nearby_point(*in_front, 20, @viewer)
        .reject { |o| o.is_a? Powerup }.empty?
  end

  def update
    @in_sight = @object_pool.nearby(@viewer, @distance)
  end

  def closest_free_path
    20.times do |i|
      x = @viewer.x + [-15, 0, 15].sample
      y = @viewer.y + [-15, 0, 15].sample
      if @object_pool.map.can_move_to?(x, y) &&
          @object_pool.nearby_point(x, y, 15, @viewer).empty?
        return [x, y]
      end
    end
    false
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

  def closest_powerup(*suitable)
    now = Gosu.milliseconds
    @closest_powerup = nil
    if now - (@powerup_cache_updated_at ||= 0) > POWERUP_CACHE_TIMEOUT
      @closest_powerup = nil
      @powerup_cache_updated_at = now
    end
    @closest_powerup ||= find_closest_powerup(*suitable)
  end

  private

  def find_closest_powerup(*suitable)
    if suitable.empty?
      suitable = [FireRatePowerup,
                  HealthPowerup,
                  RepairPowerup,
                  TankSpeedPowerup]
    end
    @in_sight.select do |o|
      suitable.include?(o.class)
    end.sort do |a, b|
      x, y = @viewer.x, @viewer.y
      d1 = Utils.distance_between(x, y, a.x, a.y)
      d2 = Utils.distance_between(x, y, b.x, b.y)
      d1 <=> d2
    end.first
  end

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
