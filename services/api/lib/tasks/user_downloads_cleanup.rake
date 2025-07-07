namespace :user_downloads do
  desc 'User download clean up tasks'
  task cleanup: :environment do
    count = 0

    UserDownload.expired.find_each do |download|
      begin
        File.delete(download.file_path) if File.exist?(download.file_path)
        download.destroy
        count += 1
      rescue => e
        Rails.logger.error("Error cleaning up ID=#{download.id}: #{e.message}")
      end
    end
  
    puts "Cleaned up #{count} expired user downloads."
  end
end
