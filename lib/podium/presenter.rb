require 'redcloth'

class Presenter
  attr_accessor :slide, :format

  def initialize(slide, opts = {})
    self.slide = slide
  end

  def to_html
    "<div class=\"slide\" id=\"slide_#{slide.number}\">#{format_slide(slide)}</div>"
  end

  def format_slide(slide)
    case slide.format 
    when "textile" : textile_format(slide.body)
    else             plain_format(  slide.body)
    end
  end

  def textile_format(body)
    RedCloth.new(body).to_html
  end

  def plain_format(body)
    body
  end
end
