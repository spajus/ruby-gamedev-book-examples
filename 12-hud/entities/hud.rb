class HUD
  attr_accessor :active
  def initialize(object_pool, player)
    @object_pool = object_pool
    @player = player
    @radar = Radar.new(@object_pool, player)
  end

  def player=(player)
    @player = player
    @radar.target = player
  end

  def update
    @radar.update
  end

  def health_image
    if @health.nil? || @player.health.health != @health
      @health = @player.health.health
      @health_image = Gosu::Image.from_text(
        $window, "Health: #{@health}", Utils.top_secret_font, 20)
    end
    @health_image
  end

  def stats_image
    stats = @player.input.stats
    if @stats_image.nil? || stats.changed_at <= Gosu.milliseconds
      @stats_image = Gosu::Image.from_text(
        $window, "Kills: #{stats.kills}", Utils.top_secret_font, 20)
    end
    @stats_image
  end

  def fire_rate_image
    if @player.fire_rate_modifier > 1
      if @fire_rate != @player.fire_rate_modifier
        @fire_rate = @player.fire_rate_modifier
        @fire_rate_image = Gosu::Image.from_text(
          $window, "Fire rate: #{(100 * @fire_rate).round}%",
          Utils.top_secret_font, 20)
      end
    else
      @fire_rate_image = nil
    end
    @fire_rate_image
  end

  def speed_image
    if @player.speed_modifier > 1
      if @speed != @player.speed_modifier
        @speed = @player.speed_modifier
        @speed_image = Gosu::Image.from_text(
          $window, "Speed: #{(100 * @speed).round}%",
          Utils.top_secret_font, 20)
      end
    else
      @speed_image = nil
    end
    @speed_image
  end

  def draw
    if @active
      @object_pool.camera.draw_crosshair
    end
    @radar.draw
    offset = 20
    health_image.draw(20, offset, 1000)
    stats_image.draw(20, offset += 30, 1000)
    if fire_rate_image
      fire_rate_image.draw(20, offset += 30, 1000)
    end
    if speed_image
      speed_image.draw(20, offset += 30, 1000)
    end
  end
end
