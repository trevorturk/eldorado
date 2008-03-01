# Prevent application from starting with incorrect database schema version (via http://pragprog.com/titles/fr_arr)
current_version = ActiveRecord::Migrator.current_version rescue 0

highest_version = Dir.glob("#{RAILS_ROOT}/db/migrate/*.rb").map { |f|
  f.match(/(\d+)_.*\.rb$/) ? $1.to_i : 0
}.max

unless defined?(Rake) # skip when run from tasks like rake db:migrate
  if current_version == 0
    abort "Database not set up. Follow instructions in README and run 'rake db:schema:load' to get started."
  elsif current_version != highest_version
    abort "Expected migration version #{highest_version}, got #{current_version}. Run 'rake db:migrate' to upgrade schema."
  end
end