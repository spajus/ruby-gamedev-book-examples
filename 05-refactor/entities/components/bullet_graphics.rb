class BulletGraphics < Component
  COLOR = Gosu::Color::BLACK

  def draw
    $window.draw_quad(object.x - 2, object.y - 2, COLOR,
                      object.x + 2, object.y - 2, COLOR,
                      object.x - 2, object.y + 2, COLOR,
                      object.x + 2, object.y + 2, COLOR,
                      1)
  end

end
