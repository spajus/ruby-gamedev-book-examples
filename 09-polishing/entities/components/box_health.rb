class BoxHealth < Component
  attr_accessor :health

  def initialize(object, object_pool)
    super(object)
    @object_pool = object_pool
    @health = 50
    @health_updated = true
    @last_damage = Gosu.milliseconds
  end

  def update
    update_image
  end

  def update_image
    return unless $debug
    if @health_updated
      text = @health.to_s
      font_size = 18
      @image = Gosu::Image.from_text(
          $window, text,
          Gosu.default_font_name, font_size)
      @health_updated = false
    end
  end

  def dead?
    @health < 1
  end

  def inflict_damage(amount)
    if @health > 0
      @health_updated = true
      @health = [@health - amount.to_i, 0].max
      if @health < 1
        Thread.new do
          sleep(rand(0.1..0.3))
          Explosion.new(@object_pool, x, y)
          sleep 1
          object.mark_for_removal
        end
      end
    end
  end

  def draw(viewport)
    return unless $debug
    @image && @image.draw(
      x - @image.width / 2,
      y - object.graphics.height / 2 -
      @image.height, 100)
  end
end
