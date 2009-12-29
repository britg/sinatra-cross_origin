begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "sinatra-cross_origin"
    gemspec.summary = "Cross Origin Resource Sharing helper for Sinatra"
    gemspec.description = gemspec.summary
    gemspec.email = "brit@britg.com"
    gemspec.homepage = "http://github.com/britg/sinatra-cross_origin"
    gemspec.authors = ["Brit Gardner"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test_all.rb']
  t.verbose = true
end

