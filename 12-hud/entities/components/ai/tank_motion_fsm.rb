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

  def draw(viewport)
    if $debug
      @image && @image.draw(
        @object.x - @image.width / 2,
        @object.y + @object.graphics.height / 2 -
        @image.height, 100)
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
    if $debug
      @image = Gosu::Image.from_text(
          $window, state.class.to_s,
          Gosu.default_font_name, 18)
    end
  end

  def choose_state
    return unless Gosu.milliseconds -
      (@last_state_change) > STATE_CHANGE_DELAY
    if @gun.target
      if @object.health.health > 40
        if @gun.distance_to_target > BulletPhysics::MAX_DIST
          new_state = @chasing_state
        else
          new_state = @fighting_state
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
