require 'helper'

FunWith::Patterns::GetAndSet.activate

class TestGetAndSet < FunWith::Patterns::TestCase
  context "basics" do
    should "be plumbed correctly" do
      assert FunWith::Patterns::GetAndSet.respond_to?(:activate), "API not installed properly"
    end
  end
  
  context "trial run" do
    should "get and set" do
      c = Class.new
      c.get_and_set( :radio, :radius, :radium )
      c.get_and_set( :radiate )
      c.get_and_set_boolean( :stringy, :flurmish )
      
      o = c.new

      pi = 3.14159
      
      assert_nil o.radius
      assert_equal pi, o.radius( pi )    # ==> 3.14159
      assert_equal pi, o.radius()             # ==> 3.14159
      assert_nil o.radium()             # ==> nil
      
      v1 = "radioactive"
      v2 = "Madame Curie"
      
      assert_equal v1, o.radium( v1 )  # ==> "radioactive"
      assert_equal v2, o.radium( v2 )  # ==> "Madame Curie"
      assert_equal v2, o.radium()                 # ==> "Madame Curie"
      
      assert_false o.stringy?
      o.stringy!
      assert_true o.stringy?
      assert_false o.not_stringy!
      assert_true !o.stringy?
      
      assert_false o.flurmish?
      assert_true o.not_flurmish?
    end
    
    should "get and set 2 : module boogaloo" do
      m = Module.new
      c = Class.new

      c.send( :include, m )
      
      m.get_and_set( :radio, :radius, :radium )
      m.get_and_set( :radiate )
      
      o = c.new

      assert_respond_to( o, :radio )
      assert_respond_to( o, :radius )
      assert_respond_to( o, :radium )
      assert_respond_to( o, :radiate )
      

      pi = 3.14159
      
      assert_nil o.radius
      assert_equal pi, o.radius( pi )    # ==> 3.14159
      assert_equal pi, o.radius()             # ==> 3.14159
      assert_nil o.radium()             # ==> nil
      
      v1 = "radioactive"
      v2 = "Madame Curie"
      
      assert_equal v1, o.radium( v1 )  # ==> "radioactive"
      assert_equal v2, o.radium( v2 )  # ==> "Madame Curie"
      assert_equal v2, o.radium()                 # ==> "Madame Curie"
    end
  end
end