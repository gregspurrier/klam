this_dir = File.dirname(__FILE__)
Dir[File.join(this_dir, 'converters', '*.rb')].each do |file|
  require file
end
