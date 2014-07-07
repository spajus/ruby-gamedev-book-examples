class PlayState < GameState
  attr_accessor :update_interval

  def initialize
    @map = Map.new
    @camera = Camera.new
    @object_pool = ObjectPool.new(@map)
    @tank = Tank.new(@object_pool, PlayerInput.new(@camera))
    @camera.target = @tank
    @radar = Radar.new(@object_pool, @tank)
    5.times do |i|
      Tank.new(@object_pool, AiInput.new(@object_pool))
    end
  end

  def update
    @object_pool.objects.map(&:update)
    @object_pool.objects.reject!(&:removable?)
    @camera.update
    @radar.update
    update_caption
    if @camera.target.health.dead?
      close_tank = @object_pool.nearby(@camera.target, 500).select do |o|
        o.class == Tank && !o.health.dead?
      end.first
      if close_tank
        @camera.target = close_tank
        @radar.target = close_tank
      end
    end
  end

  def draw
    cam_x = @camera.x
    cam_y = @camera.y
    off_x =  $window.width / 2 - cam_x
    off_y =  $window.height / 2 - cam_y
    viewport = @camera.viewport
    $window.translate(off_x, off_y) do
      zoom = @camera.zoom
      $window.scale(zoom, zoom, cam_x, cam_y) do
        @map.draw(viewport)
        @object_pool.objects.map { |o| o.draw(viewport) }
      end
    end
    @camera.draw_crosshair
    @radar.draw
  end

  def button_down(id)
    if id == Gosu::KbQ
      leave
      $window.close
    end
    if id == Gosu::KbEscape
      GameState.switch(MenuState.instance)
    end
    if id == Gosu::KbT
      t = Tank.new(@object_pool,
                   AiInput.new(@object_pool))
      t.x, t.y = @camera.mouse_coords
    end
    if id == Gosu::KbF1
      $debug = !$debug
    end
    if id == Gosu::KbF2
      toggle_profiling
    end
    if id == Gosu::KbR
      @tank.mark_for_removal
      @tank = Tank.new(@object_pool, PlayerInput.new(@camera))
      @camera.target = @tank
      @radar.target = @tank
    end
  end

  private

  def toggle_profiling
    require 'ruby-prof' unless defined?(RubyProf)
    if @profiling_now
      result = RubyProf.stop
      printer = RubyProf::FlatPrinter.new(result)
      printer.print(STDOUT)
      @profiling_now = false
    else
      RubyProf.start
      @profiling_now = true
    end
  end


  def update_caption
    now = Gosu.milliseconds
    if now - (@caption_updated_at || 0) > 1000
      $window.caption = 'Tanks Prototype. ' <<
        "[FPS: #{Gosu.fps}. " <<
        "Tank @ #{@tank.x.round}:#{@tank.y.round}]"
      @caption_updated_at = now
    end
  end
end
