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
end
