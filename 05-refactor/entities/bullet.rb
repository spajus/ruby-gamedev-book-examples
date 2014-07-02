class Bullet < GameObject
  attr_accessor :x, :y, :target_x, :target_y, :speed, :fired_at

  def initialize(object_pool, source_x, source_y, target_x, target_y)
    super(object_pool)
    @x, @y = source_x, source_y
    @target_x, @target_y = target_x, target_y
    @physics = BulletPhysics.new(self)
    @graphics = BulletGraphics.new(self)
    BulletSounds.play
  end

  def explode
    Explosion.new(object_pool, @x, @y)
    mark_for_removal
  end

  def fire(speed)
    @speed = speed
    @fired_at = Gosu.milliseconds
  end
end
