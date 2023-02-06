# frozen_string_literal: true

class DatabaseConfig
  def self.setup!
    connect!
    load_schema!
  end

  def self.database_adapter
    (ENV["ADAPTER"] || "postgresql").to_sym
  end

  def self.connect!
    ActiveRecord::Base.configurations = test_configurations
    ActiveRecord::Base.establish_connection database_adapter
  end

  def self.test_configurations
    @test_configurations ||= begin
      config_file = File.expand_path("./config.yml", __dir__)
      ActiveSupport::ConfigurationFile.parse(config_file)
    end
  end

  def self.load_schema!
    load "support/schema.rb"
  end

  private_class_method :test_configurations, :load_schema!
end
