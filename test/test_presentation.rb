require 'helper'

class TestPresentation < Test::Unit::TestCase
  context "given some slides on .new" do
    setup do 
      @slides = [Slide.new(:body => "One"), Slide.new(:body => "Two")]
      @presentation = Presentation.new(@slides)
    end

    should "include the slide bodies on to_html" do
      assert_match /One/, @presentation.to_html
      assert_match /Two/, @presentation.to_html
    end

    should "include a head element on to_html" do
      assert_match %r{<head>}, @presentation.to_html
    end
  end
end

