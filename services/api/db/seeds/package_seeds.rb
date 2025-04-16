family_gallery = Gallery.find_by(name: 'Individual & Family Portraits')
engagement_gallery = Gallery.find_by(name: 'Engagement & Couples Portraits')
product_gallery = Gallery.find_by(name: 'Product Portraits')
pet_gallery = Gallery.find_by(name: 'Pet & Animal Portraits')
event_gallery = Gallery.find_by(name: 'Event Portraits')
graduation_gallery = Gallery.find_by(name: 'Graduation & Senior Portraits')

Package.create(name: 'Basic', edited_images: 10, outfit_change: false, price: 250, duration: 30, gallery: pet_gallery, features: [
  '30-minute session',
  '1 pet',
  '1 location',
  '10 edited digital images',
  'Online gallery',
  'Print release'
])
Package.create(name: 'Standard', edited_images: 25, outfit_change: false, price: 350, duration: 60, gallery: pet_gallery, popular: true, features: [
  '1-hour session',
  'Up to 2 pets',
  '1 location',
  '25 edited digital images',
  'Online gallery',
  'Print release',
  '1 8×10 print'
])
Package.create(name: 'Premium', edited_images: 50, outfit_change: false, price: 500, duration: 120, gallery: pet_gallery, features: [
  '2-hour session',
  'Multiple pets',
  'Up to 2 locations',
  '50 edited digital images',
  'Online gallery',
  'Print release',
  '2 8×10 prints',
  'Custom pet portrait (digital)'
])

Package.create(name: 'Basic', edited_images: 10, outfit_change: true, price: 200, duration: 60, gallery: graduation_gallery, features: [
  '1 hour session',
  '1 location',
  '1 outfit',
  '10 edited digital images',
  'Online gallery',
  'Print release'
])
Package.create(name: 'Standard', edited_images: 25, outfit_change: true, price: 350, duration: 60, popular: true, gallery: graduation_gallery, features: [
  '1-hour session',
  '2 locations',
  '2 outfits',
  '25 edited digital images',
  'Online gallery',
  'Print release',
  '5 graduation announcement cards'
])
Package.create(name: 'Deluxe', edited_images: 55, outfit_change: true, price: 500, duration: 120, gallery: graduation_gallery, features: [
  '2-hour session',
  '3 locations',
  '3 outfits',
  '50 edited digital images',
  'Online gallery',
  'Print release',
  '10 graduation announcement cards',
  '1 16×20 mounted print'
])

Package.create(name: 'Mini Session', edited_images: 10, outfit_change: true, price: 200, duration: 30, gallery: family_gallery, features: [
  '30-minute session',
  '1 location',
  'Up to 5 people',
  '10 edited digital images',
  'Online gallery',
  'Print release'
])
Package.create(name: 'Family Session', edited_images: 25, outfit_change: true, price: 350, duration: 60, gallery: family_gallery, popular: true, features: [
  '1-hour session',
  '1 location',
  'Up to 8 people',
  '25 edited digital images',
  'Online gallery',
  'Print release',
  '1 8×10 family print'
])
Package.create(name: 'Extended Family', edited_images: 50, outfit_change: true, price: 550, duration: 120, gallery: family_gallery, features: [
  '2-hour session',
  '1-2 locations',
  'Large family groups',
  '50 edited digital images',
  'Online gallery',
  'Print release',
  '1 16×20 family print',
  'Individual family groupings'
])

Package.create(name: 'Simple', edited_images: 20, outfit_change: true, price: 250, duration: 60, gallery: engagement_gallery, features: [
  '1-hour session',
  '1 location',
  '1 outfit',
  '20 edited digital images',
  'Online gallery',
  'Print release'
])
Package.create(name: 'Storyteller', edited_images: 40, outfit_change: true, price: 400, duration: 120, popular: true, gallery: engagement_gallery, features: [
  '2-hour session',
  '2 locations',
  '2 outfits',
  '40 edited digital images',
  'Online gallery',
  'Print release',
  'Engagement announcement design'
])
Package.create(name: 'Adventure', edited_images: 60, outfit_change: true, price: 600, duration: 180, gallery: engagement_gallery, features: [
  '3-hour session',
  'Multiple locations',
  'Multiple outfits',
  '60 edited digital images',
  'Online gallery',
  'Print release',
  'Engagement announcement design',
  '11×14 fine art print',
  'Sunset/sunrise option'
])


Package.create(name: 'Starter', edited_images: 0, outfit_change: false, price: 300, duration: 0, popular: false, gallery: product_gallery, features: [
  'Up to 5 products',
  'White background',
  '3 angles per product',
  'Basic retouching',
  'Online gallery',
  'Commercial usage rights'
])

Package.create(name: 'E-commerce', edited_images: 0, outfit_change: false, price: 600, duration: 0, popular: true, gallery: product_gallery, features: [
  'Up to 10 products',
  'White background + 1 styled setting',
  '5 angles per product',
  'Detailed retouching',
  'Online gallery',
  'Commercial usage rights',
  'Web-optimized images'
])

Package.create(name: 'Premium', edited_images: 0, outfit_change: false, price: 1200, duration: 0, popular: false, gallery: product_gallery, features: [
  'Up to 20 products',
  'Multiple background options',
  'Lifestyle and detail shots',
  'Advanced retouching',
  'Online gallery',
  'Commercial usage rights',
  'Web and print optimized images',
  'Social media crops'
])

Package.create(name: 'Social Event Basic', edited_images: 30, outfit_change: false, price: 500, duration: 120, popular: false, gallery: event_gallery, features: [
  '2 hours of coverage',
  '1 photographer',
  '30 edited digital images',
  'Online gallery with download access',
  'Print release for personal use',
  'Delivered within 10 days',
  'Perfect for birthday parties, small gatherings'
])

Package.create(name: 'Celebration Standard', edited_images: 60, outfit_change: false, price: 950, duration: 240, popular: true, gallery: event_gallery, features: [
  '4 hours of coverage',
  '1 photographer',
  '60 edited digital images',
  'Online gallery with download access',
  'Print release for personal use',
  '10 social media highlight images within 48 hours',
  'Full gallery delivered within 10 days',
  'Event timeline consultation',
  'Ideal for anniversaries, milestone celebrations, reunions'
])

Package.create(name: 'Premium Event', edited_images: 120, outfit_change: false, price: 1800, duration: 480, popular: false, gallery: event_gallery, features: [
  '8 hours of coverage',
  '2 photographers',
  '120 edited digital images',
  'Online gallery with download access',
  'Print release for personal use',
  '15 social media highlight images within 24 hours',
  'Full gallery delivered within 10 days',
  'Event timeline consultation',
  'Custom slideshow of event highlights',
  '8×10 hardcover photo book (20 pages)',
  'Perfect for galas, fundraisers, large celebrations'
])
