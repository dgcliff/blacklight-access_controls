# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'engine_cart'
EngineCart.load_application!

require 'blacklight-access_controls'

require 'factory_bot_rails'
require 'database_cleaner'

require 'capybara/rspec'
require 'capybara/rails'

require 'rspec/rails'
require 'selenium-webdriver'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

Capybara.javascript_driver = :headless_chrome

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless disable-gpu no-sandbox] }
  )

  Capybara::Selenium::Driver.new(app,
                                 browser: :chrome,
                                 desired_capabilities: capabilities)
end

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Rails.application.routes.url_helpers
  
  config.include FactoryBot::Syntax::Methods

  config.include SolrSupport

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
  end

  config.before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end