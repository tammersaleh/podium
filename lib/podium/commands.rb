module Podium
  module Commands
    class Build
      include Podium::Helpers

      def initialize(*source_files)
        source_files.each do |source_file|
          dir      = File.dirname(source_file)
          outfile  = File.basename(source_file, ".haml")

          Dir["#{dir}/css/*.sass"].each {|f| generate_sass_file(f) }

          FileUtils.cd dir

          File.open(outfile, "w+") do |body|
            body << render("layout") do
              render(File.basename(source_file, ".html.haml"))
            end
          end
        end
      end

      def generate_sass_file(filename)
        dir = File.dirname(filename)
        outdir = "#{dir}/generated"
        FileUtils.mkdir_p(outdir)
        name = File.basename(filename, ".sass")
        outfile = "#{outdir}/#{name}.css"
        File.open(outfile, "w+") do |css_file|
          css_file << Sass::Engine.new(File.read(filename)).render
        end
      end
    end

    class New
      def initialize(directory)
        FileUtils.mkdir_p(directory)
        copy_template_files(directory)
      end

      def copy_template_files(dir)
        Dir[template_file("*")].each do |file| 
          puts "  Copying #{File.basename(file)}..."
          FileUtils.cp_r(file, dir)
        end
      end

      def template_file(file)
        File.join(File.dirname(__FILE__), "..", "..", "templates", file)
      end
    end
  end
end


