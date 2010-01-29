require 'helper'

class TestPodium < Test::Unit::TestCase
  context "when built with a plain slide without metadata" do
    setup do
      @slide = Slide.new(:body => "slide body", :number => 1, :format => "plain")
      @presenter = Presenter.new(@slide)
    end

    should "return an unformatted slide div on to_html" do
      assert_equal '<div class="slide" id="slide_1">slide body</div>', @presenter.to_html
    end
  end

  context "when built with a textile slide without metadata" do
    setup do
      @slide = Slide.new(:body => "slide *body*", :number => 1, :format => "textile")
      @presenter = Presenter.new(@slide)
    end

    should "return an unformatted slide div on to_html" do
      assert_equal '<div class="slide" id="slide_1"><p>slide <strong>body</strong></p></div>', 
                   @presenter.to_html
    end
  end
end
