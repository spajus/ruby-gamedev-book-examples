class BulletSounds

  def self.play
    sound.play
  end

  def self.sound
    @@sound ||= Gosu::Sample.new(
      $window, Game.media_path('fire.mp3'))
  end
end
