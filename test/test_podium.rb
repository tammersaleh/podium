require 'helper'

class TestPodium < Test::Unit::TestCase
  Dir[presentation_path("*")].each do |path|
    dir = File.basename(path)
    context "for the #{dir} slide directory" do
      setup do 
        @outdir = "/tmp/podium-test-outdir/#{dir}"
        FileUtils.rm_rf @outdir
        Podium.create(presentation_path(dir), @outdir)
      end

      should "create a slides.html file under the output directory" do
        assert File.size?(File.join(@outdir, "slides.html"))
      end
    end
  end
end
