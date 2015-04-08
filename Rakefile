require './boot'

namespace :db do
  Sequel.extension :migration

  desc 'Generate a timestamped, empty Sequel migration.'
  task :migration, :name do |_, args|
    if args[:name].nil?
      puts 'You must specify a migration name (e.g. rake db:migration[create_events])!'
      exit false
    end
 
    content = "Sequel.migration do\n  up do\n    \n  end\n\n  down do\n    \n  end\nend\n"
    timestamp = Time.now.to_i
    filename = File.join(File.dirname(__FILE__), 'db/migrations', "#{timestamp}_#{args[:name]}.rb")
 
    File.open(filename, 'w') do |f|
      f.puts content
    end
 
    puts "Created the migration #{filename}"
  end

  desc "Prints current schema version"
  task :version do    
    version = if DB.tables.include?(:schema_info)
      DB[:schema_info].first[:version]
    end || 0
 
    puts "Schema Version: #{version}"
  end

  desc "Perform migration up to latest migration available"
  task :migrate do
    Sequel::Migrator.run(DB, 'db/migrations')
    Rake::Task['db:version'].execute
  end

  desc "Perform migration reset (full erase and migration up)"
  task :reset do
    Sequel::Migrator.run(DB, 'db/migrations', :target => 0)
    Sequel::Migrator.run(DB, 'db/migrations')
    puts '<= db:migrate:reset executed'
  end
end
