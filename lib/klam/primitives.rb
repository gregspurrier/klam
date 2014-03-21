this_dir = File.dirname(__FILE__)
Dir[File.join(this_dir, 'primitives', '*.rb')].each do |file|
  require file
end
