require_relative '../entities/map'
require_relative '../entities/tank'
require_relative '../entities/camera'
require_relative '../entities/bullet'
require_relative '../entities/explosion'
class PlayState < GameState

  def initialize
    @map = Map.new
    @tank = Tank.new(@map)
    @camera = Camera.new(@tank)
    @bullets = []
    @explosions = []
  end

  def update
    bullet = @tank.update(@camera)
    @bullets << bullet if bullet
    @bullets.map(&:update)
    @bullets.reject!(&:done?)
    @camera.update
    $window.caption = 'Tanks Prototype. ' <<
      "[FPS: #{Gosu.fps}. Tank @ #{@tank.x.round}:#{@tank.y.round}]"
  end

  def draw
    cam_x = @camera.x
    cam_y = @camera.y
    off_x =  $window.width / 2 - cam_x
    off_y =  $window.height / 2 - cam_y
    $window.translate(off_x, off_y) do
      zoom = @camera.zoom
      $window.scale(zoom, zoom, cam_x, cam_y) do
        @map.draw(@camera)
        @tank.draw
        @bullets.map(&:draw)
      end
    end
    @camera.draw_crosshair
  end

  def button_down(id)
    if id == Gosu::MsLeft
      bullet = @tank.shoot(*@camera.mouse_coords)
      @bullets << bullet if bullet
    end
    $window.close if id == Gosu::KbQ
    if id == Gosu::KbEscape
      GameState.switch(MenuState.instance)
    end
  end

end
