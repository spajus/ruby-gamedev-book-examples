require 'singleton'
class MenuState < GameState
  include Singleton
  attr_accessor :play_state

  def initialize
    @message = Gosu::Image.from_text(
      $window, "Tanks Prototype",
      Gosu.default_font_name, 100)
  end

  def enter
    music.play(true)
    music.volume = 1
  end

  def leave
    music.volume = 0
    music.stop
  end

  def music
    @@music ||= Gosu::Song.new(
      $window, Utils.media_path('menu_music.mp3'))
  end

  def update
    continue_text = @play_state ? "C = Continue, " : ""
    @info = Gosu::Image.from_text(
      $window, "Q = Quit, #{continue_text}N = New Game",
      Gosu.default_font_name, 30)
  end

  def draw
    @message.draw(
      $window.width / 2 - @message.width / 2,
      $window.height / 2 - @message.height / 2,
      10)
    @info.draw(
      $window.width / 2 - @info.width / 2,
      $window.height / 2 - @info.height / 2 + 200,
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
  end
end
