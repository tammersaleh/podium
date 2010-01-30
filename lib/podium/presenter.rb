require 'redcloth'

class Presenter
  attr_accessor :slide

  def self.recognize_filename?(filename)
    %w(md).include?(File.basename(filename[/[^\.]*$/]))
  end

  def initialize(slide, opts = {})
    self.slide = slide
  end

  def to_html
    "<div class=\"slide\" id=\"slide_#{slide.number}\">#{format_slide(slide)}</div>"
  end

  def format_slide(slide)
    body = case slide.format 
    when "textile" : textile_format(slide.body)
    else             plain_format(  slide.body)
    end

    return munge_asset_paths(body, asset_path(slide))
  end

  def textile_format(body)
    RedCloth.new(body).to_html
  end

  def plain_format(body)
    body
  end

  def munge_asset_paths(body, path)
    body.gsub(%r{src="assets/}) do |match|
      'src="' + path + "assets/"
    end
  end

  def asset_path(slide)
    return "" if slide.source_file.blank?
    dir = File.dirname(slide.source_file)
    return "" if dir == "."
    return dir + "/"
  end
end
