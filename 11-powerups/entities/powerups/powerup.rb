class Powerup < GameObject
  def initialize(object_pool, x, y)
    super
    PowerupGraphics.new(self, graphics)
  end

  def box
    [x - 8, y - 8,
     x + 8, y - 8,
     x + 8, y + 8,
     x - 8, y + 8]
  end

  def on_collision(object)
    if pickup(object)
      PowerupSounds.play(object, object_pool.camera)
      mark_for_removal
    end
  end

  def pickup(object)
    # override and implement
  end

  def mark_for_removal
    object_pool.powerup_respawner.enqueue(
      respawn_delay,
      self.class, x, y)
    super
  end

  def respawn_delay
    30
  end
end
