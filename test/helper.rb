require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'podium'

class Test::Unit::TestCase
  def self.presentations_path
		File.join(File.dirname(__FILE__), "example_presentations")
  end

  def self.presentation_path(name)
		File.join(presentations_path, name)
  end

  def presentation_path(name)
    self.class.presentation_path(name)
  end
end
