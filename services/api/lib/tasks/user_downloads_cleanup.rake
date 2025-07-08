namespace :user_downloads do
  desc 'User download clean up tasks'
  task cleanup: :environment do
    count = 0

    UserDownload.expired.find_each { |download| count += 1 if download.destroy }

    puts "Cleaned up #{count} expired user downloads."
  end
end
