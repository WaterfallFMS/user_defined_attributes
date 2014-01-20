require 'rubygems'

RSpec.configure do |config|
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.mock_with :rspec

  config.before(:each) do
    if example.metadata[:js]
      DatabaseCleaner.strategy = :truncation, {:except => %w[roles states settings content_types]}
    elsif example.metadata[:search]
      DatabaseCleaner.strategy = :truncation, {:except => %w[roles states settings content_types]}
      ThinkingSphinx::Test.init
      ThinkingSphinx::Test.start_with_autostop
    else
      DatabaseCleaner.strategy = :transaction
    end
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.alias_it_should_behave_like_to :it_has_behavior,         'has behavior:'
  config.alias_it_should_behave_like_to :it_should_have_attached, 'it has attached'

   config.before(:suite) do
    set_theme if respond_to? :set_theme
  end
  config.before(:each) do
    Timecop.return
    #FakeWeb.clean_registry

    # don't keep an audit log for normal tests
    PaperTrail.enabled = false
  end

  config.before(:each, :audit => true) do
    PaperTrail.enabled = true
  end
end
# end

# Spork.each_run do
# This code will be run each time you run your specs.

# end
