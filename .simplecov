require 'simplecov'

SimpleCov.start 'rails' do
  add_filter 'app/channels/application_cable'
  add_filter 'app/jobs/'
end