require 'active_support'
require 'podium/slide'
require 'podium/presenter'
require 'podium/file_finder'

class Podium
  def self.create(presentation_directory, output_directory)
    FileUtils.mkdir_p(output_directory)
    slide_file = File.join(output_directory, "slides.html")
    File.open(slide_file, "w+") do |file|
      FileFinder.new(presentation_directory).slides.each do |slide|
        file << Presenter.new(slide).to_html
      end
    end
  end
end
