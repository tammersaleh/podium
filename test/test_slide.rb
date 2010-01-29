require 'helper'

class TestSlide < Test::Unit::TestCase
  context "when creating a slide" do
    setup { @slide = Slide.new }

    should "record the slide number" do
      assert_equal 1, @slide.number
    end

    context "and another" do
      setup { @slide = Slide.new }

      should "record the slide number" do
        assert_equal 2, @slide.number
      end
    end

    teardown { Slide.reset_count! }
  end

  context ".collection_from_text" do
    context "when given text for two slides" do
      setup do
        @contents = <<-EOS
!SLIDE

one

!SLIDE

two
EOS
        @slides = Slide.collection_from_text(@contents)
      end

      should "return an array of slides" do
        assert_equal([Slide.new(:body => "one"),
                      Slide.new(:body => "two")], 
                     @slides)
      end
    end

    context "when given text for a slide with metadata" do
      setup do
        @contents = <<-EOS
!SLIDE red color:green

one
EOS
        @slides = Slide.collection_from_text(@contents)
      end

      should "return an array of slides" do
        assert_equal([Slide.new(:meta => ["red", "color:green"], :body => "one")], 
                     @slides)
      end
    end

    teardown { Slide.reset_count! }
  end

  # context "slide_div" do
  #   context "with slide data without metadata" do
  #     setup { @output = Podium.slide_div({:meta => [], })}
  #   end
  # end
end

