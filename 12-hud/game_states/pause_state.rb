require 'singleton'
class PauseState < GameState
  include Singleton
  attr_accessor :play_state

  def initialize
    @message = Gosu::Image.from_text(
      $window, "Game Paused",
      Utils.top_secret_font, 60)
  end

  def enter
    music.play(true)
    music.volume = 1
    @score_display = ScoreDisplay.new(@play_state.object_pool)
    @mouse_coords = [$window.mouse_x, $window.mouse_y]
  end

  def leave
    music.volume = 0
    music.stop
    $window.mouse_x, $window.mouse_y = @mouse_coords
  end

  def music
    @@music ||= Gosu::Song.new(
      $window, Utils.media_path('menu_music.mp3'))
  end

  def update
    continue_text = @play_state ? "C = Continue, " : ""
    @info = Gosu::Image.from_text(
      $window, "Q = Quit, #{continue_text}N = New Game",
      Utils.top_secret_font, 30)
  end

  def draw
    @play_state.draw
    @message.draw(
      $window.width / 2 - @message.width / 2,
      $window.height / 4 - @message.height,
      1000)
    @score_display.draw
  end

  def button_down(id)
    $window.close if id == Gosu::KbQ
    if id == Gosu::KbC && @play_state
      GameState.switch(@play_state)
    end
    if id == Gosu::KbEscape
      GameState.switch(@play_state)
    end
  end
end
