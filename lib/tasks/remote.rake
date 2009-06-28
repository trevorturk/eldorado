namespace :test do
  desc "Run remote tests"
  task :remote do
    Dir.glob('test/remote/*.rb').each do |file|
      ruby file
    end
  end
end