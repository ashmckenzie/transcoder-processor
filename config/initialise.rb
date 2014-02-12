lib = File.expand_path(File.join('..', '..', 'lib', 'transcoder_processor'), __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

initialisers_path = File.expand_path(File.join('..', '..', 'config', 'initialisers', '**', '*.rb'), __FILE__)

Dir[initialisers_path].each do |file|
  require file
end

lib_path = File.expand_path(File.join('..', '..', 'lib', 'transcoder_processor', '**', '*.rb'), __FILE__)

Dir[lib_path].each do |file|
  require file
end
