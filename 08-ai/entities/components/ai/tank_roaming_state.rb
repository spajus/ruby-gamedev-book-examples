class TankRoamingState
  def initialize(object, vision)
    @object = object
    @vision = vision
  end

  def update
    change_direction if should_change_direction?
    if substate_expired?
      rand > 0.3 ? drive : wait
    end
  end

  def on_collision(with)
    change = case rand(0..100)
    when 0..30
      -90
    when 30..60
      90
    when 60..70
      135
    when 80..90
      -135
    else
      180
    end
    @object.physics.change_direction(
      @object.direction + change)
  end

  def wait
    @sub_state = :waiting
    @started_waiting = Gosu.milliseconds
    @will_wait_for = wait_time
    @object.throttle_down = false
  end

  def drive
    @sub_state = :driving
    @started_driving = Gosu.milliseconds
    @will_drive_for = drive_time
    @object.throttle_down = true
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

  def should_change_direction?
    return true unless @changed_direction_at
    Gosu.milliseconds - @changed_direction_at > @will_keep_direction_for
  end

  def substate_expired?
    now = Gosu.milliseconds
    case @sub_state
    when :waiting
      true if now - @started_waiting > @will_wait_for
    when :driving
      true if now - @started_driving > @will_drive_for
    else
      true
    end
  end

  def wait_time
    rand(1000..2000)
  end

  def drive_time
    rand(500..1000)
  end

  def turn_time
    rand(400..2000)
  end
end
