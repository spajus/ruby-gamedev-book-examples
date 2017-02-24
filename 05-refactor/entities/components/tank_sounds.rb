class TankSounds < Component
  def update
    if object.physics.moving?
      if @driving && @driving.paused?
        @driving.resume
      elsif @driving.nil?
        @driving = driving_sound.play(1, 1, true) if driving_sound
      end
    else
      if @driving && @driving.playing?
        @driving.pause
      end
    end
  end

  def collide
    crash_sound.play(1, 0.25, false) if crash_sound
  end

  private

  def driving_sound
    @@driving_sound ||= Gosu::Sample.new(
      $window, Utils.media_path('tank_driving.ogg'))
  end

  def crash_sound
    @@crash_sound ||= Gosu::Sample.new(
      $window, Utils.media_path('crash.ogg'))
  end
end
