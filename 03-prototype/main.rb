require 'gosu'
require_relative 'game_state'
require_relative 'menu_state'
require_relative 'play_state'
require_relative 'game_window'

module Game
  def self.media_path(file)
    File.join(File.dirname(__FILE__), 'media', file)
  end
end

$window = GameWindow.new
#MenuState.instance.play_state = $window.state = PlayState.new
GameState.switch(MenuState.instance)
$window.show

