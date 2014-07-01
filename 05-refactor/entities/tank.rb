class Tank < GameObject
  SHOOT_DELAY = 500
  attr_accessor :x, :y, :throttle_down, :direction, :gun_angle,
                :input, :physics, :graphics, :sounds

  def initialize(map, input)
    @map = map
    @x, @y = @map.find_spawn_point
    @direction = @gun_angle = 0.0
    @input = input
    @input.control(self)
    @physics = TankPhysics.new(self, @map)
    @graphics = TankGraphics.new(self)
    @sounds = TankSounds.new(self)
    @map.objects << self
  end

  def update
    @input.update
    @physics.update
    @sounds.update
  end

  def draw(viewport)
    @graphics.draw(viewport)
  end

  def speed
    @physics.speed
  end

  def shoot(target_x, target_y)
    if Gosu.milliseconds - (@last_shot || 0) > SHOOT_DELAY
      @last_shot = Gosu.milliseconds
      @map.objects << Bullet.new(@map, @x, @y, target_x, target_y).fire(100)
    end
  end
end
