require 'deliver'
require 'fastimage'

module Frameit
  class Runner
    def initialize
      converter = FrameConverter.new
      unless converter.frames_exist?
        # First run
        converter.run
      else
        # Just make sure, the PSD files are converted to PNG
        converter.convert_frames
      end
    end

    def run(path, color = Color::BLACK)
      screenshots = Dir.glob("#{path}/**/*.{png,PNG}")

      if screenshots.count > 0
        screenshots.each do |full_path|
          next if full_path.include?"_framed.png"
          next if full_path.include?".itmsp/" # a package file, we don't want to modify that
          next if full_path.include?"device_frames/" # these are the device frames the user is using
          
          begin
            screenshot = Screenshot.new(full_path, color)
            screenshot.frame!
          rescue => ex
            Helper.log.error ex
          end
        end
      else 
        Helper.log.error "Could not find screenshots"
      end
    end
  end
end