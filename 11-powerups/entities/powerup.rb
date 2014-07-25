class Powerup < GameObject

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
