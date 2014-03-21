this_dir = File.dirname(__FILE__)
Dir[File.join(this_dir, 'compilation_stages', '*.rb')].each do |file|
  require file
end
