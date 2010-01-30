require 'helper'

class TestFileFinder < Test::Unit::TestCase
	context "a new file finder for a simple presentation" do
		setup do
			@file_finder = FileFinder.new(presentation_path("simple"))
		end

		should "find the files" do
			assert_equal ["slides.md"], 
				           @file_finder.slide_files.map {|f| File.basename f }
		end

		should "find the slides" do
			assert_equal [Slide.new(:body => "one"), Slide.new(:body => "two")], @file_finder.slides
		end
	end

	context "a new file finder for a nested presentation" do
		setup do
			@file_finder = FileFinder.new(presentation_path("nested"))
		end

		should "find the files" do
			assert_equal %w(first.md second.md third.md z_fourth.md), 
				           @file_finder.slide_files.map {|f| File.basename f }
		end

		should "find the slides" do
			assert_equal [Slide.new(:body => "one"), 
				            Slide.new(:body => "two"), 
				            Slide.new(:body => "three"), 
				            Slide.new(:body => "four")], 
									 @file_finder.slides
		end

    should "record the source filename on the slide" do
			assert_equal %w(first.md
                      subdir/second.md
                      subdir/subsubdir/third.md
                      z_fourth.md), 
									 @file_finder.slides.map(&:source_file)
    end
	end

	context "a new file finder for a nested presentation with slide_list.txt files" do
		setup do
			@file_finder = FileFinder.new(presentation_path("complex"))
		end

		should "find the files" do
			assert_equal %w(1_first.md 0_second.md 0_third.md), 
				           @file_finder.slide_files.map {|f| File.basename f }
		end

		should "find the slides" do
			assert_equal [Slide.new(:body => "one"), 
				            Slide.new(:body => "two"), 
				            Slide.new(:body => "three")], 
									 @file_finder.slides
		end
	end

	context "a new file finder for a nested presentation with assets" do
		setup do
			@file_finder = FileFinder.new(presentation_path("nested_with_assets"))
		end

		should "find the files" do
			assert_equal %w(one.md two.md), 
				           @file_finder.slide_files.map {|f| File.basename f }
		end
	end

  %w(assets shared . ..).each do |directory_name|
    should "know to ignore #{directory_name} directories" do
      assert FileFinder.new("foo").ignore?(directory_name)
    end
  end

  %w(foo bar).each do |directory_name|
    should "know to not ignore #{directory_name} directories" do
      assert !FileFinder.new("foo").ignore?(directory_name)
    end
  end
end
