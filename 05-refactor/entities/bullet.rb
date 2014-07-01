class Bullet < GameObject
  attr_accessor :x, :y, :target_x, :target_y, :speed, :fired_at

  def initialize(map, source_x, source_y, target_x, target_y)
    @map = map
    @x, @y = source_x, source_y
    @target_x, @target_y = target_x, target_y
    @physics = BulletPhysics.new(self)
    @graphics = BulletGraphics.new(self)
    BulletSounds.play
  end

  def update
    @physics.update
  end

  def explode
    @map.objects << Explosion.new(@x, @y)
    mark_for_removal
  end

  def draw(viewport)
    @graphics.draw
  end

  def fire(speed)
    @speed = speed
    @fired_at = Gosu.milliseconds
    self
  end

end
