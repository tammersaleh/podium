module Podium
  module Helpers
    def ts
      Time.now.to_i
    end

    def css(name)
      "<link href='css/generated/#{name}.css?#{ts}' media='all' rel='stylesheet' type='text/css'>"
    end

    def javascript(name)
      "<script src='javascript/#{name}.js?#{ts}' type='text/javascript'></script>"
    end

    def render(filename, &block)
      Haml::Engine.new(File.read(filename + ".html.haml")).render(binding, &block)
    end
  end
end
