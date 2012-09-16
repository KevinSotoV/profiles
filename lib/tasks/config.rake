namespace :profiles do
  namespace :config do
    desc 'Create configuration files'
    task :create do
      require 'fileutils'
      FileUtils.cp Rails.root.join('config/settings.yml.example'), Rails.root.join('config/settings.yml')
      FileUtils.cp Rails.root.join('config/database.yml.example'), Rails.root.join('config/database.yml')
      puts "Config files created. Don't forget to edit the files:\n  config/settings.yml\n  config/database.yml"
    end
  end
end
