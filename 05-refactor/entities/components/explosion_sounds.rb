class ExplosionSounds
  class << self
    def play
      sound.play
    end

    private

    def sound
      @@sound ||= Gosu::Sample.new(
        $window, Utils.media_path('explosion.mp3'))
    end
  end
end

