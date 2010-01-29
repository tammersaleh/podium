require 'helper'

class TestPodium < Test::Unit::TestCase
  context "the splitter" do
    context "when given two slides" do
      setup do
        @contents = <<-EOS
!SLIDE

one

!SLIDE

two
EOS
        @output = Podium.split_contents(@contents)
      end

      should "return an array of hashes" do
        assert_equal([{:meta => [], :body => "one"},
                      {:meta => [], :body => "two"}], 
                     @output)
      end
    end

    context "when given a slide with metadata" do
      setup do
        @contents = <<-EOS
!SLIDE red color:green

one
EOS
        @output = Podium.split_contents(@contents)
      end

      should "return an array of hashes" do
        assert_equal([{:meta => ["red", "color:green"], :body => "one"}], 
                     @output)
      end
    end
  end
end
