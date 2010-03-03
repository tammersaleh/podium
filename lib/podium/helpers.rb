module Podium
  module Helpers
    def ts
      Time.now.to_i
    end

    def css(name)
      "<link href='assets/#{name}.css?#{ts}' media='all' rel='stylesheet' type='text/css'>"
    end

    def javascript(name)
      "<script src='assets/#{name}.js?#{ts}' type='text/javascript'></script>"
    end

    def image(name, opts = {})
      attributes = opts.map {|k,v| "#{k}='#{v}'"}.join(' ')
      "<img src='assets/#{name}' #{attributes}/>"
    end

    def podium_css(name)
      "<link href='podium/css/#{name}.css?#{ts}' media='all' rel='stylesheet' type='text/css'>"
    end

    def podium_javascript(name)
      "<script src='podium/javascript/#{name}.js?#{ts}' type='text/javascript'></script>"
    end

    def render(filename, &block)
      Haml::Engine.new(File.read(filename + ".html.haml")).render(binding, &block)
    end
  end
end
