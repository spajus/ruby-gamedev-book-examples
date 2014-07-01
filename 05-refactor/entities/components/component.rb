class Component
  def initialize(game_object)
    @object = game_object
  end

  protected

  def set_object(obj)
    @object = obj
  end

  def object
    @object
  end
end
