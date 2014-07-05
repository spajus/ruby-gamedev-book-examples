module Utils
  def self.media_path(file)
    File.join(File.dirname(File.dirname(
      __FILE__)), 'media', file)
  end

  def self.track_update_interval
    now = Gosu.milliseconds
    @update_interval = (now - (@last_update ||= 0)).to_f
    @last_update = now
  end

  def self.update_interval
    @update_interval ||= $window.update_interval
  end

  def self.adjust_speed(speed)
    speed * update_interval / 33.33
  end

  def self.button_down?(button)
    @buttons ||= {}
    now = Gosu.milliseconds
    now = now - (now % 150)
    if $window.button_down?(button)
      @buttons[button] = now
      true
    elsif @buttons[button]
      if now == @buttons[button]
        true
      else
        @buttons.delete(button)
        false
      end
    end
  end

  def self.rotate(angle, around_x, around_y, *points)
    result = []
    angle = angle * Math::PI / 180.0
    points.each_slice(2) do |x, y|
      r_x = Math.cos(angle) * (around_x - x) - Math.sin(angle) * (around_y - y) + around_x
      r_y = Math.sin(angle) * (around_x - x) + Math.cos(angle) * (around_y - y) + around_y
      result << r_x
      result << r_y
    end
    result
  end

  # http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html
  def self.point_in_poly(testx, testy, *poly)
    nvert = poly.size / 2 # Number of vertices in poly
    vertx = []
    verty = []
    poly.each_slice(2) do |x, y|
      vertx << x
      verty << y
    end
    inside = false
    j = nvert - 1
    (0..nvert - 1).each do |i|
      if (((verty[i] > testy) != (verty[j] > testy)) &&
         (testx < (vertx[j] - vertx[i]) * (testy - verty[i]) /
         (verty[j] - verty[i]) + vertx[i]))
        inside = !inside
      end
      j = i
    end
    inside
  end

  def self.distance_between(x1, y1, x2, y2)
    dx = x1 - x2
    dy = y1 - y2
    Math.sqrt(dx * dx + dy * dy)
  end

  def self.angle_between(x, y, target_x, target_y)
    dx = target_x - x
    dy = target_y - y
    (180 - Math.atan2(dx, dy) * 180 / Math::PI) + 360 % 360
  end
end
