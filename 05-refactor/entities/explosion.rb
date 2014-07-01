class Explosion < GameObject
  attr_accessor :x, :y

  def initialize(x, y)
    @x, @y = x, y
    @graphics = ExplosionGraphics.new(self)
    ExplosionSounds.play
  end

  def update
    @graphics.update
  end

  def draw(viewport)
    @graphics.draw
  end
end
