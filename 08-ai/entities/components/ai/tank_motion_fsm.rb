class TankMotionFSM
  STATE_CHANGE_DELAY = 500
  def initialize(object, vision, gun)
    @object = object
    @vision = vision
    @gun = gun
    @roaming_state = TankRoamingState.new(object, vision)
    @fighting_state = TankFightingState.new(object, vision)
    @fleeing_state = TankFleeingState.new(object, vision, gun)
    @chasing_state = TankChasingState.new(object, vision, gun)
    set_state(@roaming_state)
  end

  def on_collision(with)
    @current_state.on_collision(with)
  end

  def on_damage(amount)
    if @current_state == @roaming_state
      set_state(@fighting_state)
    end
  end

  def update
    choose_state
    @current_state.update
  end

  def set_state(state)
    return unless state
    return if state == @current_state
    @last_state_change = Gosu.milliseconds
    @current_state = state
    state.enter
  end

  def choose_state
    return unless Gosu.milliseconds -
      (@last_state_change) > STATE_CHANGE_DELAY

    if @gun.target
      if @object.health.health > 40
        new_state = if @gun.distance_to_target > BulletPhysics::MAX_DIST
                      @chasing_state
                    else
                      @fighting_state
                    end
      else
        if @fleeing_state.can_flee?
          new_state = @fleeing_state
        else
          new_state = @fighting_state
        end
      end
    else
      new_state = @roaming_state
    end
    set_state(new_state)
  end
end
