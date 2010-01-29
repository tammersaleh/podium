class FileFinder
  attr_accessor :presentation_directory

  def initialize(directory)
    self.presentation_directory = directory
  end

  def slide_files(dir = nil)
    dir ||= self.presentation_directory

    files = []

    file_list(dir).each do |file_or_directory| 
      next if %w(. ..).include?(File.basename(file_or_directory))

      if File.directory?(file_or_directory)
        files += slide_files(file_or_directory)
      else
        files << file_or_directory
      end
    end

    return files
  end

  def file_list(dir)
    explicit_file_list_file = File.join(dir, "file_list.txt")
    if File.exists?(explicit_file_list_file)
      File.read(explicit_file_list_file).map { |filename| File.join(dir, filename.strip) }
    else
      Dir[File.join(dir, "*")]
    end
  end

  def slides_for_file(file)
    Slide.collection_from_text(File.read(file))
  end

  def slides
    slide_files.inject([]) do |slides, file|
      slides += slides_for_file(file)
    end
  end
end
