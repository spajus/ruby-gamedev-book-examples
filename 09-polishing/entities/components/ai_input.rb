class AiInput < Component
  UPDATE_RATE = 200 # ms
  NAME_COLOR = Gosu::Color.argb(0xeeb10000)
  attr_reader :name

  def initialize(name, object_pool)
    @object_pool = object_pool
    @name = name
    super(nil)
    @last_update = Gosu.milliseconds
  end

  def control(obj)
    self.object = obj
    object.components << self
    @vision = AiVision.new(obj, @object_pool,
                           rand(700..1200))
    @gun = AiGun.new(obj, @vision)
    @motion = TankMotionFSM.new(obj, @vision, @gun)
  end

  def on_collision(with)
    return if object.health.dead?
    @motion.on_collision(with)
  end

  def on_damage(amount)
    @motion.on_damage(amount)
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

  def draw(viewport)
    @motion.draw(viewport)
    @gun.draw(viewport)
    @name_image ||= Gosu::Image.from_text(
      $window, @name, Gosu.default_font_name, 20)
    @name_image.draw(
      x - @name_image.width / 2 - 1,
      y + object.graphics.height / 2, 100,
      1, 1, Gosu::Color::WHITE)
    @name_image.draw(
      x - @name_image.width / 2,
      y + object.graphics.height / 2, 100,
      1, 1, NAME_COLOR)
  end
end
