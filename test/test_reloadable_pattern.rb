require 'helper'

class TestReloadablePattern < FunWith::Patterns::TestCase
  context "testing basics" do
    setup do
      Class.send( :include, FunWith::Patterns::Reloadable )
      assert_has_instance_method( Class, :reload! )
      assert_has_instance_method( Class, :reloadable! )
      
      assert_respond_to( Object, :reload!)
      assert_respond_to( Object, :reloadable!)
    end
    
    should "reload MyReloadable" do
      refute defined?(MyReloadable)
      FunWith::Patterns.root( "test", "reloadable", "my_reloadable.rb" ).requir
      assert defined?(MyReloadable)
      assert_respond_to( MyReloadable.new, :square )
      
      MyReloadable.class_eval do
        remove_method :square
      end
      
      refute_respond_to( MyReloadable.new, :square )
      
      MyReloadable.reload!
      
      assert defined?(MyReloadable)
      
      assert_respond_to( MyReloadable.new, :square )
      
      
    end
  end
end