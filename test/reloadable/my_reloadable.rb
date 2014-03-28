class MyReloadable
  reloadable!
  
  def square( x )
    x * x
  end
end

puts "FINISHED LOADING #{__FILE__}"