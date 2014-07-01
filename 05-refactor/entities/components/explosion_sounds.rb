class ExplosionSounds
  def self.play
    sound.play
  end

  def self.sound
    @@sound ||= Gosu::Sample.new(
      $window, Game.media_path('explosion.mp3'))
  end
end

