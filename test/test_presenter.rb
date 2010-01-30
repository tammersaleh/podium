require 'helper'

class TestPresenter < Test::Unit::TestCase
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

  context "when built with a root slide referencing an asset" do
    setup do
      @slide = Slide.new(:body => "!assets/foo.jpg!", :format => "textile", :source_file => "file.textile")
      @presenter = Presenter.new(@slide)
    end

    should "not change the asset path" do
      assert_match %r{"assets/foo.jpg"}, @presenter.to_html
    end
  end

  context "when built with a root slide referencing an asset" do
    setup do
      @slide = Slide.new(:body => "!assets/foo.jpg!", :format => "textile", :source_file => "subdir/file.textile")
      @presenter = Presenter.new(@slide)
    end

    should "change the asset path to include the subdirectory" do
      assert_match %r{"subdir/assets/foo.jpg"}, @presenter.to_html
    end
  end

  %(md).each do |extension|
    should "recognize file.#{extension} files" do
      assert Presenter.recognize_filename?("path/to/file.#{extension}")
    end
  end

  %(jpg png).each do |extension|
    should "not recognize file.#{extension} files" do
      assert !Presenter.recognize_filename?("path/to/file.#{extension}")
    end
  end
end
