module Podium
  module Commands
    class Build
      include Podium::Helpers

      def initialize(*source_files)
        source_files.each do |source_file|
          dir      = File.dirname(source_file)
          outfile  = File.basename(source_file, ".haml")

          FileUtils.cd dir

          File.open(outfile, "w+") do |body|
            body << Haml::Engine.new(File.read("podium/layout.html.haml")).render(binding) do
              Haml::Engine.new(File.read(source_file)).render(binding)
            end
          end
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


