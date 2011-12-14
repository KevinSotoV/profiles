namespace :profiles do
  namespace :export do
    desc 'Export data as CSV'
    task :csv => :environment do
      require 'csv'

      fields = Profile.first.attributes.keys

      out = CSV.generate do |csv|
        csv << (fields + ['email'])
        Profile.all.each do |profile|
          row = fields.map { |f| profile[f] }
          row << profile.user.email
          csv << row
        end
      end
      puts out
    end
  end
end
