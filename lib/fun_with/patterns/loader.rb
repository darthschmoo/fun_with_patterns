module FunWith
  module Patterns
    module Loader
      def self.included( base )
        base.extend( ClassMethods )
        base.extend( LoadingStyles::Eval ) # provides a default load_item method
        base.loader_pattern_extension( :rb ) if base.loader_pattern_extension.nil?
      end
    end
  end
end