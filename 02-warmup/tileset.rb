require 'json'
class Tileset
  def initialize(window, json)
    @json = JSON.parse(File.read(json))
    image_file = File.join(
      File.dirname(json), @json['meta']['image'])
    @main_image = Gosu::Image.new(
      @window, image_file, true)
  end

  def frame(name)
    f = @json['frames'][name]['frame']
    @main_image.subimage(
      f['x'], f['y'], f['w'], f['h'])
  end
end
