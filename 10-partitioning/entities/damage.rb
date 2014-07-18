class Damage < GameObject
  MAX_INSTANCES = 100
  attr_accessor :x, :y
  @@instances = []

  def initialize(object_pool, x, y)
    super(object_pool)
    DamageGraphics.new(self)
    @x, @y = x, y
    track(self)
  end

  def effect?
    true
  end

  private

  def track(instance)
    if @@instances.size < MAX_INSTANCES
      @@instances << instance
    else
      out = @@instances.shift
      out.mark_for_removal
      @@instances << instance
    end
  end
end
