require_relative 'map'
require_relative 'tank'
require_relative 'camera'
require_relative 'bullet'
require_relative 'explosion'
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
    $window.caption = "Tanks Prototype. [FPS: #{Gosu.fps}. Tank @ #{@tank.x.round}:#{@tank.y.round}]"
  end

  def draw
    off_x = -@camera.x + $window.width / 2
    off_y = -@camera.y + $window.height / 2
    cam_x = @camera.x
    cam_y = @camera.y
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
    bullet = @tank.shoot(*@camera.mouse_coords) if id == Gosu::MsLeft
    @bullets << bullet if bullet
    $window.close if id == Gosu::KbQ
    GameState.switch(MenuState.instance) if id == Gosu::KbEscape
  end

end
