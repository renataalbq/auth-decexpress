require 'simplecov'

SimpleCov.start 'rails' do
  add_filter 'app/channels/application_cable'
  add_filter 'app/workers/'
  add_filter 'app/models/ability.rb'
  add_filter 'app/jobs/'
  add_filter 'lib/tasks/'
  add_filter 'app/controllers/users_controller.rb'
  add_filter 'app/models/user.rb'
  add_filter 'app/controllers/application_controller.rb'
  add_filter 'app/services/history_pdf_service.rb'
end