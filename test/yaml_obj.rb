require 'yaml'


# Change the behavior by overriding loader_pattern_load_item( file )
# Uses custom method, not LoadingStyle::YAML
class YamlObj
  include FunWith::Patterns::Loader
  
  attr_accessor :label, :password, :host, :login
  alias :loader_pattern_registry_key :label
  
  # The class initializes via yaml strings.
  def self.loader_pattern_load_item( file )
    obj = self.new( file.read )
    self.loader_pattern_register_item( obj )
  end
  
  def initialize( yaml )
    yaml = Psych.load( yaml )
    
    @login    = yaml["login"]
    @password = self.decrypt( yaml["password"] )
    @host     = yaml["host"]
    @label    = yaml["label"]
  end
  
  # Warning: not production cryptography code.
  def decrypt( str )
    num = 13
    
    bytes = str.split("").map(&:bytes).map(&:first)
    
    lower_a = 'a'.bytes.first
    upper_a = 'A'.bytes.first
    is_lowercase = (lower_a .. (lower_a + 26))
    is_uppercase = (upper_a .. (upper_a + 26))
    rot_bytes = bytes.map{ |ch|
      case ch
      when is_lowercase
        ((ch + num - lower_a) % 26 + lower_a)
      when is_uppercase
        ((ch + num - upper_a) % 26 + upper_a)
      else
        ch
      end
    }
    
    rot_bytes.map(&:chr).join("")
  end
end