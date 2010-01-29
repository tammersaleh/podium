class Slide
  mattr_accessor :total_slides
  self.total_slides = 1
  attr_accessor :body, :meta, :number, :format

  def self.collection_from_text(text)
    text.split("!SLIDE").reject(&:blank?).inject([]) do |array, section_body|
      array << Slide.new(:meta => extract_metadata!(section_body), 
                         :body => section_body.strip)
    end
  end

  def self.extract_metadata!(string)
    metadata_string = nil
    string.sub!(/.*$/) {|match| metadata_string = match; nil}
    metadata_string.split(" ")
  end

  def self.reset_count!
    self.total_slides = 1
  end

  def self.next_slide_number
    number = self.total_slides
    self.total_slides += 1
    return number
  end

  def initialize(opts = {})
    self.body   = opts[:body]
    self.format = opts[:format]
    self.meta   = opts[:meta] || []
    self.number = opts[:number] || self.class.next_slide_number
  end

  def ==(other)
    self.body == other.body and self.meta == other.meta
  end
end
