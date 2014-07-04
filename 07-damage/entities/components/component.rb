class Component
  def initialize(game_object = nil)
    self.object = game_object
  end

  def update
    # override
  end

  def draw(viewport)
    # override
  end

  protected

  def object=(obj)
    if obj
      @object = obj
      obj.components << self
    end
  end

  def x
    @object.x
  end

  def y
    @object.y
  end

  def object
    @object
  end
end
