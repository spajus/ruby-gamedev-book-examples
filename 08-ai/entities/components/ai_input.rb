class AiInput < Component

  UPDATE_RATE = 200 # ms
  def initialize(object_pool)
    @object_pool = object_pool
    super(nil)
    @last_update = Gosu.milliseconds
    @retarget_speed = rand(1..5)
    @target = nil
  end

  def control(obj)
    self.object = obj
    @vision = AiVision.new(obj, @object_pool, rand(300..700))
    @desired_gun_angle = rand(0..360)
  end

  def update
    adjust_gun_angle
    now = Gosu.milliseconds
    if @target
      @desired_gun_angle = Utils.angle_between(x, y, @target.x, @target.y)
    else
      @desired_gun_angle = object.direction
    end
    return if now - @last_update < UPDATE_RATE
    @last_update = now
    @vision.update
    if @vision.in_sight.any?
      if @vision.closest_tank != @target
        change_target(@vision.closest_tank)
      end
    end
  end

  def change_target(new_target)
    puts "Changing target from #{@target} to #{new_target}"
    @target = new_target
  end

  def adjust_gun_angle
    actual = object.gun_angle
    desired = @desired_gun_angle
    if actual > desired
      if actual - desired > 180 # 0 -> 360 fix
        object.gun_angle = (actual + @retarget_speed) % 360
        if object.gun_angle < desired
          object.gun_angle = desired # damp
        end
      else
        object.gun_angle = [actual - @retarget_speed, desired].max
      end
    elsif actual < desired
      if desired - actual > 180 # 360 -> 0 fix
        object.gun_angle = (360 + actual - @retarget_speed) % 360
        if object.gun_angle > desired
          object.gun_angle = desired # damp
        end
      else
        object.gun_angle = [actual + @retarget_speed, desired].min
      end
    end
  end

end
