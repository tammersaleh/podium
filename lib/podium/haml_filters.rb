module HtmlCode
  include Haml::Filters::Base
  def render(text)
    "<pre><code class='html'>#{Haml::Helpers.html_escape(text).sub(/^\n*/, "").rstrip}</code></pre>"
  end

  def compile(precompiler, text)
    resolve_lazy_requires
    filter = self
    precompiler.instance_eval do
      rendered = Haml::Helpers::find_and_preserve(filter.render_with_options(text, precompiler.options), precompiler.options[:preserve])

      push_text(rendered.rstrip.gsub("\n", "\n#{'  ' * @output_tabs}"))
    end
  end
end

module RubyCode
  include Haml::Filters::Base
  def render(text)
    "<pre><code class='ruby'>#{Haml::Helpers.html_escape(text).sub(/^\n*/, "").rstrip}</code></pre>"
  end

  def compile(precompiler, text)
    resolve_lazy_requires
    filter = self
    precompiler.instance_eval do
      rendered = Haml::Helpers::find_and_preserve(filter.render_with_options(text, precompiler.options), precompiler.options[:preserve])

      push_text(rendered.rstrip.gsub("\n", "\n#{'  ' * @output_tabs}"))
    end
  end
end

module Code
  include Haml::Filters::Base
  def render(text)
    "<pre><code>#{Haml::Helpers.html_escape(text).sub(/^\n*/, "").rstrip}</code></pre>"
  end

  def compile(precompiler, text)
    resolve_lazy_requires
    filter = self
    precompiler.instance_eval do
      rendered = Haml::Helpers::find_and_preserve(filter.render_with_options(text, precompiler.options), precompiler.options[:preserve])

      push_text(rendered.rstrip.gsub("\n", "\n#{'  ' * @output_tabs}"))
    end
  end
end
