require 'machinist/active_record'
require 'faker'
require 'sham'

Sham.login { Faker::Name.first_name }
Sham.email { Faker::Internet.email }
Sham.file_name { Faker::Lorem.words(2).join('.') }

Upload.blueprint do
  user { User.make }
  attachment_file_name { Sham.file_name }
end

User.blueprint do
  login { Sham.login }
  email { Sham.email }
  password 'test'
end
