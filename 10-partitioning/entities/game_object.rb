class GameObject
  def initialize(object_pool)
    @components = []
    @object_pool = object_pool
    @object_pool.objects << self
  end

  def components
    @components
  end

  def update
    @components.map(&:update)
  end

  def draw(viewport)
    @components.each { |c| c.draw(viewport) }
  end

  def removable?
    @removable
  end

  def mark_for_removal
    @removable = true
  end

  def on_collision(object)
  end

  def effect?
    false
  end

  def box
  end

  def collide
  end

  protected

  def object_pool
    @object_pool
  end
end
