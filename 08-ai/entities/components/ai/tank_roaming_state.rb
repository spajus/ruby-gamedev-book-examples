class TankRoamingState < TankMotionState
  def initialize(object, vision)
    super
    @object = object
    @vision = vision
  end

  def update
    change_direction if should_change_direction?
    if substate_expired?
      rand > 0.3 ? drive : wait
    end
  end

  def change_direction
    change = case rand(0..100)
    when 0..30
      -45
    when 30..60
      45
    when 60..70
      90
    when 80..90
      -90
    else
      0
    end
    if change != 0
      @object.physics.change_direction(
        @object.direction + change)
    end
    @changed_direction_at = Gosu.milliseconds
    @will_keep_direction_for = turn_time
  end

  def wait_time
    rand(500..2000)
  end

  def drive_time
    rand(1000..5000)
  end

  def turn_time
    rand(2000..5000)
  end
end
