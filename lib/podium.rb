require 'active_support'
require 'podium/slide'
require 'podium/presenter'
require 'podium/file_finder'

class Podium
  attr_accessor :in_dir, :out_dir

  def initialize(presentation_directory, output_directory)
    self.in_dir = presentation_directory
    self.out_dir = output_directory
  end

  def create!
    make_out_dir!

    File.open(output_slide_file, "w+") do |file|
      file << slides_text
    end
  end

  def make_out_dir!
    FileUtils.mkdir_p(out_dir)
  end

  def slides
    FileFinder.new(in_dir).slides
  end

  def slides_text
    slides.map { |slide| Presenter.new(slide).to_html }.join
  end

  def output_slide_file
    File.join(out_dir, "slides.html")
  end
end
