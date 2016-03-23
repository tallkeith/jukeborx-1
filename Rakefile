require "bundler/gem_tasks"
require "rake/testtask"
require "yaml"
require "active_record"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

namespace :db do
  db_config = YAML.load(File.open("config/database.yml"))
  ActiveRecord::Base.establish_connection(db_config)

  desc "Run migrations"
  task :migrate do
    version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    ActiveRecord::Migrator.migrate("db/migrate", version)
  end
end

task :default => :spec
