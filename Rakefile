# frozen_string_literal: true

require "rake/testtask"

def run_without_aborting(*tasks)
  errors = []

  tasks.each do |task|
    Rake::Task[task].invoke
  rescue Exception
    errors << task
  end

  abort "Errors running #{errors.join(', ')}" if errors.any?
end

desc "Run tests with all adapters by default"
task default: :test

desc "Run tests with all adapters"
task :test do
  run_without_aborting(*["test:postgresql", "test:mysql"])
end

task :coverage do
  rm_rf "coverage/"
  ENV["COVERAGE"] = "true"

  task = Rake::Task["test"]
  task.reenable
  task.invoke

  SimpleCov.collate Dir["coverage/.resultset-*.json"] do
    formatter SimpleCov::Formatter::MultiFormatter.new(
      [
        SimpleCov::Formatter::SimpleFormatter,
        SimpleCov::Formatter::HTMLFormatter
      ]
    )
  end
end

namespace :test do
  %w[postgresql mysql].each do |adapter|
    Rake::TestTask.new(adapter => "#{adapter}:env") do |t|
      t.libs << "test"
      t.test_files = FileList["test/**/*_test.rb"]
    end
  end
end

namespace :postgresql do
  task :env do
    ENV["ADAPTER"] = "postgresql"

    %w[PGHOST PGUSER PGPASSWORD].each { |key| ENV[key] = "postgres" }
  end

  task build: :env do
    %x[createdb --encoding=UTF8 --template=template0 --lc-collate=en_US.UTF-8 postgresql_test]
  end

  task drop: :env do
    %x[dropdb --if-exists postgresql_test]
  end

  task rebuild: [:env, :drop, :build]
end

namespace :mysql do
  task :env do
    ENV["ADAPTER"] = "mysql"
  end

  task build: :env do
    %x[mysql --host=mysql --user=root --password=mysql -e "create DATABASE mysql_test DEFAULT CHARACTER SET utf8mb4"]
  end

  task drop: :env do
    %x[mysqladmin --host=mysql --user=root --password=mysql -f DROP mysql_test]
  end

  task rebuild: [:env, :drop, :build]
end
