class TankMotionFSM
  def initialize(object, vision)
    @object = object
    @vision = vision
    @roaming_state = TankRoamingState.new(object, vision)
    @current_state = @roaming_state
  end

  def on_collision(with)
    @current_state.on_collision(with)
  end

  def update
    @current_state.update
  end
end
