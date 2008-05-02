# Create database, load initial schema, or migrate as necessary (via http://pragprog.com/titles/fr_arr)
unless defined?(Rake) # skip when loaded from rake tasks
  ActiveRecord::Base.transaction do
    load "#{RAILS_ROOT}/Rakefile"
    begin
      current_version = ActiveRecord::Migrator.current_version
      highest_version = Dir.glob("#{RAILS_ROOT}/db/migrate/*.rb").map { |f| f.match(/(\d+)_\w*\.rb$/) ? $1.to_i : 0 }.max
      Rake::Task["db:migrate"].invoke if current_version != highest_version
    rescue
      Rake::Task["db:create"].invoke
      abort 'ERROR: Database has no schema version and is not empty' unless ActiveRecord::Base.connection.tables.blank?
      Rake::Task["db:schema:load"].invoke
    end
  end
end