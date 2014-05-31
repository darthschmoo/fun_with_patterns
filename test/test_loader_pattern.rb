require 'helper'

class TestLoaderPattern < FunWith::Patterns::TestCase
  context "testing basics" do
    should "have all the pieces in place" do
      assert defined?( FunWith::Patterns )
      assert defined?( FunWith::Patterns::Loader )
      assert defined?( FunWith::Patterns::Loader::ClassMethods )
    end    
  end
  
  context "testing User" do
    setup do
      User.loader_pattern_load_from_dir( FunWith::Patterns.root( "test", "users" ) )
      User2.loader_pattern_load_from_dir( FunWith::Patterns.root( "test", "users" ) )
    end
    
    should "have all the right methods" do
      for method in [ :loader_pattern_extension,
                      :loader_pattern_verbose,
                      :loader_pattern_load_item,
                      :loader_pattern_register_item,
                      :loader_pattern_load_from_dir,
                      :loader_pattern_configure ]
        assert_respond_to( User, method )
      end
    end
    
    should "load users from test/users and test/users/more" do
      assert User.loader_pattern_registry_lookup("Gary Milhouse")
      assert_equal 54, User.loader_pattern_registry_lookup("Gary Milhouse").age
    end
    
    should "lookup via brackets" do
      User.loader_pattern_configure( :bracketwise_lookup )
      assert_equal 54, User["Gary Milhouse"].age
      
      # User2 class is already configured for bracketwise lookup
      m = User2["Gary Milhouse"]
      assert_kind_of( User, m )
      assert_equal 54, m.age
    end
  end
  
  context "testing YamlObj (non-standard loader)" do
    setup do
      YamlObj.loader_pattern_extension( "yaml" )
      YamlObj.loader_pattern_load_from_dir( FunWith::Patterns.root( "test", "yamls" ) )
    end
    
    should "look up items in registry" do
      obj = YamlObj.loader_pattern_registry_lookup("Steve's Instagram Login")
      assert_not_nil obj
      assert_equal "password", obj.password
    end
  end
end

   