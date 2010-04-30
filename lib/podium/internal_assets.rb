class Podium::InternalAssets < Sinatra::Base
  set :root,         File.join(File.dirname(__FILE__), *%w(.. ..))
  set :public,       proc { File.join(root, "public") }
  set :environment,  proc { Podium.environment }

  enable :logging, :static
end
