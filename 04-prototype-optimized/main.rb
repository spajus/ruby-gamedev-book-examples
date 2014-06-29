require 'gosu'
require_relative 'states/game_state'
require_relative 'states/menu_state'
require_relative 'states/play_state'
require_relative 'game_window'

module Game
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
end

$window = GameWindow.new
GameState.switch(MenuState.instance)
$window.show
