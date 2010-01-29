require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'podium'

# require 'fakefs'

class Test::Unit::TestCase
  def presentation_path(name)
		File.join(File.dirname(__FILE__), "example_presentations", name)
  end
end
