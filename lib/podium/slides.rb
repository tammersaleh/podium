class Podium::Slides < Sinatra::Base
  Layout = File.read(File.join(File.dirname(__FILE__), *%w(.. .. views layout.haml)))

  set :root,         proc { Podium.root_dir                                 }
  set :views,        proc { Podium.slides_dir  or File.join(root, "slides") }
  set :public,       proc { Podium.assets_dir  or File.join(root, "assets") }
  set :environment,  proc { Podium.environment or ENV['RACK_ENV'].to_sym    }

  enable :logging, :static

  helpers Sinatra::UrlForHelper
  helpers Podium::Helpers
  register Sinatra::StaticAssets

  get %r{(.+)} do |path|
    haml File.join(path, "index").to_sym, :layout => Podium::Slides::Layout
  end
end
