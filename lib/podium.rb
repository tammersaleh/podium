require 'active_support'

class Podium
  def self.split_contents(contents)
    contents.split("!SLIDE").reject(&:blank?).inject([]) do |array, section_body|
      array << {:meta => extract_metadata!(section_body), 
                :body => section_body.strip}
    end
  end

  def self.extract_metadata!(string)
    metadata_string = nil
    string.sub!(/.*$/) {|match| metadata_string = match; nil}
    metadata_string.split(" ")
  end
end
