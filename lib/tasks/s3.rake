namespace :s3 do
  task :create => :environment do
    puts "Reading config/config.yml and creating a bucket on s3 for the production environment..."
    CONFIG = YAML.load_file('config/config.yml')['production'] rescue {}
    s3 = RightAws::S3.new(CONFIG['s3_access_id'], CONFIG['s3_secret_key'])
    RightAws::S3::Bucket.create(s3, CONFIG['s3_bucket_name'], true)
    s3.bucket(CONFIG['s3_bucket_name'])
    puts "OK"
  end
end