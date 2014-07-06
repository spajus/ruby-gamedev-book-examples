class AiInput < Component

  UPDATE_RATE = 200 # ms
  def initialize(object_pool)
    @object_pool = object_pool
    super(nil)
    @last_update = Gosu.milliseconds
  end

  def control(obj)
    self.object = obj
    @vision = AiVision.new(obj, @object_pool, rand(300..700))
    @gun = AiGun.new(obj, @vision)
    @motion = TankMotionFSM.new(obj, @vision, @gun)
  end

  def on_collision(with)
    @motion.on_collision(with)
  end

  def update
    return if object.health.dead?
    @gun.adjust_angle
    now = Gosu.milliseconds
    return if now - @last_update < UPDATE_RATE
    @last_update = now
    @vision.update
    @gun.update
    @motion.update
  end
end
