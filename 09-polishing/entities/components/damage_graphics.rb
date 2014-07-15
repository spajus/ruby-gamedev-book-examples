class DamageGraphics < Component
  def draw(viewport)
    image.draw(x - 32, y - 32, 1)
  end

  private

  def image
    @@image ||= Gosu::Image.new(
      $window, Utils.media_path('damage1.png'), false)
  end
end
