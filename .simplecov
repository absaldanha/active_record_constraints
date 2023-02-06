# frozen_string_literal: true

SimpleCov.start do
  load_profile "test_frameworks"

  # enable_coverage :branch
  minimum_coverage 100
  refuse_coverage_drop

  command_name "#{SimpleCov.command_name}-#{ENV["ADAPTER"]}"

  add_filter "version.rb"
  track_files "lib/**/*.rb"
end
