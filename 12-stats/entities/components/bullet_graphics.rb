class BulletGraphics < Component
  def draw(viewport)
    image.draw(x - 8, y - 8, 1)
    Utils.mark_corners(object.box) if $debug
  end

  private

  def image
    @@bullet ||= Gosu::Image.new(
      $window, Utils.media_path('bullet.png'), false)
  end
end
