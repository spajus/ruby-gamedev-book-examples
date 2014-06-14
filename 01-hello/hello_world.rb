require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super(320, 240, false)
    self.caption = 'Hello'
    @message = Gosu::Image.from_text(
      self, 'Hello, World!', Gosu::default_font_name, 30)
  end

  def update
  end

  def draw
    @message.draw(10, 10, 0)
  end
end

window = GameWindow.new
window.show
