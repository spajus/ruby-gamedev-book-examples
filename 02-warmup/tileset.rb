require 'json'
module Gosu
  module TexturePacker
    class Tileset

      def self.load_json(window, json)
        self.new(window, json)
      end

      def initialize(window, json)
        @window = window
        @json = JSON.parse(File.read(json))
        @source_dir = File.dirname(json)
        @main_image = Gosu::Image.new(@window, image_file, true)
        @tile_cache = {}
      end

      def frame_list
        frames.keys
      end

      def frame(name)
        tile = @tile_cache[name]
        unless tile
          data = frames[name]
          f = data['frame']
          tile = @main_image.subimage(f['x'], f['y'], f['w'], f['h'])
          @tile_cache[name] = tile
        end
        tile
      end

      private

      def image_file
        File.join(@source_dir, meta['image'])
      end

      def meta
        @json['meta']
      end

      def frames
        @json['frames']
      end

    end
  end
end
