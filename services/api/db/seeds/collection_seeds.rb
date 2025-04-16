family_gallery = Gallery.find_by(name: 'Individual & Family Portraits')
engagement_gallery = Gallery.find_by(name: 'Engagement & Couples Portraits')
product_gallery = Gallery.find_by(name: 'Product Portraits')
pet_gallery = Gallery.find_by(name: 'Pet & Animal Portraits')
event_gallery = Gallery.find_by(name: 'Event Portraits')
graduation_gallery = Gallery.find_by(name: 'Graduation & Senior Portraits')

Collection.create(name: 'Leah Newhouse Wedding Ceremony', gallery: engagement_gallery)
Collection.create(name: 'Trung Nguyen Wedding Reception', gallery: engagement_gallery)
Collection.create(name: 'Vika Glitter Portraits', gallery: family_gallery)
Collection.create(name: 'The Heyday Family', gallery: family_gallery)
Collection.create(name: 'Michaela and The Babies', gallery: pet_gallery)
Collection.create(name: 'RDNE Graduation Celebration', gallery: graduation_gallery)
Collection.create(name: 'The z500x Camera', gallery: product_gallery)
Collection.create(name: "Maria kurnyk's Bakery", gallery: product_gallery)
Collection.create(name: 'Thibault Trillet Concert', gallery: event_gallery)
