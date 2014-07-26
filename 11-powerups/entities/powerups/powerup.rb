class Powerup < GameObject
  def initialize(object_pool, x, y)
    super
    gfx = PowerupGraphics.new(self)
    gfx.type = graphics
  end

  def box
    [x - 8, y - 8,
     x + 8, y - 8,
     x + 8, y + 8,
     x - 8, y + 8]
  end

  def on_collision(object)
    PowerupSounds.play(object, object_pool.camera)
    mark_for_removal
  end
end
