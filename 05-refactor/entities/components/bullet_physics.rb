class BulletPhysics < Component
  START_DIST = 20
  MAX_DIST = 300

  def initialize(object)
    super(object)
    object.x, object.y = point_at_distance(START_DIST)
    if trajectory_length > MAX_DIST
      object.target_x, object.target_y = point_at_distance(MAX_DIST)
    end
  end

  def update
    fly_speed = Game.adjust_speed(object.speed)
    fly_distance = (Gosu.milliseconds - object.fired_at) * 0.001 * fly_speed
    object.x, object.y = point_at_distance(fly_distance)
    object.explode if arrived?
  end

  def trajectory_length
    d_x = object.target_x - object.x
    d_y = object.target_y - object.y
    Math.sqrt(d_x * d_x + d_y * d_y)
  end

  def point_at_distance(distance)
    return [object.target_x, object.target_y] if distance > trajectory_length
    distance_factor = distance.to_f / trajectory_length
    p_x = object.x + (object.target_x - object.x) * distance_factor
    p_y = object.y + (object.target_y - object.y) * distance_factor
    [p_x, p_y]
  end

  private

  def arrived?
    object.x == object.target_x && object.y == object.target_y
  end
end
