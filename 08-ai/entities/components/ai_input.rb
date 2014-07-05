class AiInput < Component
  def control(obj)
    self.object = obj
    @enabled = rand > 0.2
  end

  def update
    return false unless @enabled
    return if object.health.dead?
    if object.physics.in_collision &&
      object.physics.collides_with.class != Bullet
      change = case rand
               when 0..0.33
                 135
               when 0.33..0.66
                 315
               else
                 180
               end
      object.physics.change_direction(
        object.direction + change)
    end
    now = Gosu.milliseconds
    @direction_changed_at ||= now
    @next_direction_change ||= rand(500..3000)
    if now - @direction_changed_at > @next_direction_change
      change = case rand
               when 0..0.1
                 180
               when 0.1..0.3
                 90
               when 0.3..0.5
                 -90
               when 0.5..0.75
                 45
               when 0.75..1
                 -45
               end
      object.physics.change_direction(
        object.direction + change)
      @direction_changed_at = now
      @next_direction_change = rand(2000..5000)
      object.throttle_down = rand > 0.15
    end
  end
end
