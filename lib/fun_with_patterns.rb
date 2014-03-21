require 'fun_with_files'
require 'fun_with_version_strings'

module FunWith
  module Patterns
  end
end

FunWith::Files::RootPath.rootify( FunWith::Patterns, __FILE__.fwf_filepath.dirname.up )
FunWith::VersionStrings.version( FunWith::Patterns )

FunWith::Patterns.root("lib", "fun_with").requir