require 'singleton'
class MenuState < GameState
  include Singleton
  attr_accessor :play_state

  def initialize
    @message = Gosu::Image.from_text(
      $window, "Tanks Prototype",
      Utils.title_font, 60)
  end

  def enter
    if music
      music.play(true)
      music.volume = 1
    end
  end

  def leave
    if music
      music.volume = 0
      music.stop
    end
  end

  def music
    @@music ||= Gosu::Song.new(
      $window, Utils.media_path('menu_music.ogg'))
  end

  def update
    text = "Q: Quit\nN: New Game\nD: Demo"
    text << "\nC: Continue" if @play_state
    @info = Gosu::Image.from_text(
      $window, text,
      Utils.main_font, 30)
  end

  def draw
    @message.draw(
      $window.width / 2 - @message.width / 2,
      $window.height / 2 - @message.height / 2,
      10)
    @info.draw(
      $window.width / 2 - @info.width / 2,
      $window.height / 2 - @info.height / 2 + 100,
      10)
  end

  def button_down(id)
    $window.close if id == Gosu::KbQ
    if id == Gosu::KbC && @play_state
      GameState.switch(@play_state)
    end
    if id == Gosu::KbN
      @play_state = PlayState.new
      GameState.switch(@play_state)
    end
    if id == Gosu::KbD
      @play_state = DemoState.new
      GameState.switch(@play_state)
    end
  end
end
