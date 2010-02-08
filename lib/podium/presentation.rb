class Presentation
  attr_accessor :slides

  def initialize(presentation_slides)
    self.slides = presentation_slides
  end

  def slide_texts
    slides.map { |slide| Formatter.new(slide).to_html }.join
  end

  def template_path
    File.join(File.dirname(__FILE__), "..", "..", "templates", "layout.html.haml")
  end

  def to_html
    Haml::Engine.new(File.read(template_path)).render(binding)
  end
end
