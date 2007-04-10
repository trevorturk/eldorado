namespace :db do
   desc "Imports PunBB content"
   task :import => :environment do
     eld = pun = ActiveRecord::Base.configurations
     ActiveRecord::Base.establish_connection(eld[RAILS_ENV])
     puts 'el dorado development database info:'
     puts eld[RAILS_ENV].inspect
     puts 'punbb database name:'
     # pun[RAILS_ENV]['database'] = STDIN.gets.chomp
     pun[RAILS_ENV]['database'] = 'newathens_20070409'
     puts pun[RAILS_ENV].inspect
     ActiveRecord::Base.establish_connection(pun[RAILS_ENV])
     ActiveRecord::Base.connection.tables.each { |t| puts t }
     puts ActiveRecord::Base.connection.tables.inspect     
     categories = ActiveRecord::Base.find_by_sql('SELECT * FROM pun_categories')
     categories.each do |cat|
       puts cat.attributes.inspect
     end
   end
 end