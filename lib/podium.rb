$LOAD_PATH << File.join(File.dirname(__FILE__), "podium")

require "sinatra/base"
require "haml"
require "active_support"
require "sinatra/static_assets"

class Podium
  mattr_accessor :root_dir    # Root directory for all podium subdirectories.

  mattr_accessor :environment # For overriding RACK_ENV

  mattr_accessor :slides_dir  # Directory to find the haml slide files.  Defaults to root_dir/slides

  mattr_accessor :assets_dir  # Directory to find the local images, css, & javascript files.  
                              # Defaults to root_dir/assets
  
  mattr_accessor :base_path   # Mount point for the presentation.  Defaults to "/slides"

  self.base_path = "/foo"

  def initialize(app)
    @app = app

    @podium_app = Rack::Builder.new do
      map "#{Podium.base_path}/internal" do
        run Podium::InternalAssets
      end

      map "#{Podium.base_path}" do
        run Podium::Slides
      end
    end
  end

  def call(env)
    path = env["PATH_INFO"].to_s
    if path.starts_with?(Podium.base_path)
      @podium_app.call(env)
    else
      @app.call(env)
    end
  end
end

%w(helpers haml_filters slides internal_assets).each do |library|
  require File.join(File.dirname(__FILE__), "podium", library)
end
