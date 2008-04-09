# Load initial schema or migrate database if necessary (via http://pragprog.com/titles/fr_arr)
unless defined?(Rake) # skip when loaded from rake tasks
  load "#{RAILS_ROOT}/Rakefile"
  begin
    current_version = ActiveRecord::Migrator.current_version
    highest_version = Dir.glob("#{RAILS_ROOT}/db/migrate/*.rb").map { |f| f.match(/(\d+)_.*\.rb$/) ? $1.to_i : 0 }.max
    Rake::Task["db:migrate"].invoke if current_version != highest_version
  rescue
    abort 'ERROR: Database has no schema version and is not empty' unless ActiveRecord::Base.connection.tables.blank?
    Rake::Task["db:schema:load"].invoke
    retry
  end
end