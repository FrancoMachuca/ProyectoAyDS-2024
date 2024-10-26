require 'active_record'
require 'yaml'
require 'rake'

test_db = YAML.load_file('config/database.yml')['test']

ActiveRecord::Base.establish_connection(test_db)

load 'Rakefile'
Rake::Task['db:drop:_unsafe'].invoke
Rake::Task['db:prepare'].invoke
