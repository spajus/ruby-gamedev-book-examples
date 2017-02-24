class ExplosionSounds
  class << self
    def play
      sound.play if sound
    end

    private

    def sound
      @@sound ||= Gosu::Sample.new(
        $window, Utils.media_path('explosion.ogg'))
    end
  end
end

