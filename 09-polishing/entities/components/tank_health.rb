class TankHealth < Health
  attr_accessor :health

  def initialize(object, object_pool)
    super(object, object_pool, 100, true)
  end

  protected

  def draw?
    true
  end

  def after_death
    Thread.new do
      sleep(rand(0.1..0.3))
      Explosion.new(@object_pool, x, y)
    end
  end
end
