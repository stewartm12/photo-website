# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Load gallery_seeds.rb first
load Rails.root.join('db', 'seeds', 'gallery_seeds.rb')
load Rails.root.join('db', 'seeds', 'slideshow_seeds.rb')

# Load the rest of the seed files (excluding gallery_seeds.rb since it's already loaded)
if Rails.env.development?
  Dir[Rails.root.join('db', 'seeds', '*.rb')].each do |file|
    next if file.include?('gallery_seeds.rb') || file.include?('slideshow_seeds.rb')
    load file
  end
end
