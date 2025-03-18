family_gallery = Gallery.find_by(name: 'Individual & Family Portraits')
engagement_gallery = Gallery.find_by(name: 'Engagement & Couples Portraits')
corporate_gallery = Gallery.find_by(name: 'Corporate & Commercial Portraits')
product_gallery = Gallery.find_by(name: 'Product Portraits')
pet_gallery = Gallery.find_by(name: 'Pet & Animal Portraits')
event_gallery = Gallery.find_by(name: 'Event Portraits')
graduation_gallery = Gallery.find_by(name: 'Graduation & Senior Portraits')

AddOn.create(name: 'Additional pet', price: 50, limited: false, gallery: pet_gallery)
AddOn.create(name: 'Additional location', price: 75, limited: false, gallery: pet_gallery)
AddOn.create(name: 'Extra digital images', price: 15, limited: false, gallery: pet_gallery)
AddOn.create(name: 'Custom pet portrait', price: 100, limited: false, gallery: pet_gallery)
AddOn.create(name: 'Pet photo album', price: 200, limited: true, gallery: pet_gallery)

AddOn.create(name: 'Additional outfit', price: 50, limited: false, gallery: graduation_gallery)
AddOn.create(name: 'Additional location', price: 75, limited: false, gallery: graduation_gallery)
AddOn.create(name: 'Extra digital images', price: 15, limited: false, gallery: graduation_gallery)
AddOn.create(name: 'Graduation announcements (set of 25)', price: 75, limited: false, gallery: graduation_gallery)
AddOn.create(name: 'Cap and gown mini-session', price: 100, limited: true, gallery: graduation_gallery)

AddOn.create(name: 'Additional family members (beyond package limit)', price: 25, limited: false, gallery: family_gallery)
AddOn.create(name: 'Additional location', price: 75, limited: false, gallery: family_gallery)
AddOn.create(name: 'Extra digital images', price: 15, limited: false, gallery: family_gallery)
AddOn.create(name: 'Family photo album', price: 250, limited: true, gallery: family_gallery)
AddOn.create(name: 'Holiday card design', price: 75, limited: true, gallery: family_gallery)

AddOn.create(name: 'Additional hour', price: 150, limited: false, gallery: engagement_gallery)
AddOn.create(name: 'Additional location', price: 75, limited: false, gallery: engagement_gallery)
AddOn.create(name: 'Extra digital images', price: 15, limited: false, gallery: engagement_gallery)
AddOn.create(name: 'Save the Date design', price: 250, limited: false, gallery: engagement_gallery)
AddOn.create(name: 'Engagement guest book', price: 75, limited: true, gallery: engagement_gallery)

AddOn.create(name: 'Additional employee headshots', price: 50, limited: false, gallery: corporate_gallery)
AddOn.create(name: 'Location Change', price: 100, limited: false, gallery: corporate_gallery)
AddOn.create(name: 'Rush Delivery', price: 200, limited: true, gallery: corporate_gallery)
AddOn.create(name: 'Social Media Content Package', price: 300, limited: true, gallery: corporate_gallery)

AddOn.create(name: 'Additional hour of coverage', price: 200, limited: false, gallery: event_gallery)
AddOn.create(name: 'Second photographer (4 hours)', price: 400, limited: true, gallery: event_gallery)
AddOn.create(name: 'Rush delivery (48 hours)', price: 250, limited: true, gallery: event_gallery)
AddOn.create(name: 'Professional event album (30 pages)', price: 450, limited: true, gallery: event_gallery)
AddOn.create(name: 'Custom branded photo backdrop', price: 300, limited: true, gallery: event_gallery)

AddOn.create(name: 'Additional products', price: 300, limited: false, gallery: product_gallery)
AddOn.create(name: '360° product rotation', price: 750, limited: true, gallery: product_gallery)
AddOn.create(name: 'Lifestyle/context shots', price: 100, limited: true, gallery: product_gallery)
AddOn.create(name: 'Product video clips (15 sec)', price: 150, limited: true, gallery: product_gallery)
