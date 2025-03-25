# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if Rails.env.development? && Gallery.count.zero?
  # Load gallery_seeds.rb and showcase_seeds.rb first
  require Rails.root.join('db', 'seeds', 'gallery_seeds.rb')
  require Rails.root.join('db', 'seeds', 'showcase_seeds.rb')

  # Then load any other seed files, skipping the ones already loaded
  Dir[Rails.root.join('db', 'seeds', '*.rb')].each do |file|
    next if file.include?('gallery_seeds.rb') || file.include?('showcase_seeds.rb')
    require file
  end
end
