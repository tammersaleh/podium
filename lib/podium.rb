require 'active_support'
require 'haml'
require 'podium/slide'
require 'podium/formatter'
require 'podium/file_finder'
require 'podium/presentation'

class Podium
  attr_accessor :in_dir, :out_dir

  def initialize(presentation_directory, output_directory)
    self.in_dir = presentation_directory
    self.out_dir = output_directory
  end

  def create!
    make_out_dir!

    File.open(output_slide_file, "w+") do |file|
      file << presentation.to_html
    end
  end

  def make_out_dir!
    FileUtils.mkdir_p(out_dir)
  end

  def slides
    FileFinder.new(in_dir).slides
  end

  def presentation
    Presentation.new(slides)
  end

  def output_slide_file
    File.join(out_dir, "slides.html")
  end
end
