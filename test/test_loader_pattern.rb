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
      User1.loader_pattern_load_from_dir( FunWith::Patterns.root( "test", "users", "eval" ) )
      User2.loader_pattern_load_from_dir( FunWith::Patterns.root( "test", "users", "eval" ) )
      User3.loader_pattern_load_from_dir( FunWith::Patterns.root( "test", "users", "instance_exec" ) )
      User4.loader_pattern_load_from_dir( FunWith::Patterns.root( "test", "users", "yaml" ) )
      User5.loader_pattern_load_from_dir( FunWith::Patterns.root( "test", "users", "yaml" ) )
      
      @user_classes = [User1, User2, User3, User4, User5]
    end
    
    should "have all the right methods" do
      for method in [ :loader_pattern_extension,
                      :loader_pattern_verbose,
                      :loader_pattern_load_item,
                      :loader_pattern_register_item,
                      :loader_pattern_load_from_dir,
                      :loader_pattern_configure ]
        for klass in @user_classes
          assert_respond_to( klass, method, "#{klass} should respond to ##{method}" )
        end
      end
    end
    
    should "load users from test/users into various classes" do
      for klass in @user_classes[0..3]
        assert klass.loader_pattern_registry_lookup("Gary Milhouse"), "#{klass} did not load Gary.  Poor Gary."
        assert_equal 54, klass.loader_pattern_registry_lookup("Gary Milhouse").age, "#{klass} did not load Gary with proper age data."
      end
        
      # User5 uses different keys, so handling separately
      assert_equal 53, User5["wanda"].age
      assert_equal "Wanda Wimbledon", User5["wanda"].name
    end
    
    should "lookup via brackets" do
      User1.loader_pattern_configure( :bracketwise_lookup )
      assert_equal 54, User1["Gary Milhouse"].age
      
      # User2 class is already configured for bracketwise lookup
      m = User2["Gary Milhouse"]
      assert_kind_of( User1, m )
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

   