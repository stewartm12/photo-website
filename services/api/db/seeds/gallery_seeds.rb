user = User.create!(
  first_name: 'John',
  last_name: 'Doe',
  email_address: 'johndoe@test.com',
  confirmed_at: Time.now,
  confirmation_sent_at: Time.now,
  password: 'Password123!',
  password_confirmation: 'Password123!'
)

store = Store.create!(name: 'Test Store', domain: 'test-store', owner: user, email: 'store@email.com')

StoreMembership.create!(user: user, store: store)

Gallery.create!(
  name: 'Individual & Family Portraits',
  description: 'Timeless portraits that capture the unique bond of your family',
  active: true,
  store: store
)
Gallery.create(
  name: 'Engagement & Couples Portraits',
  description: 'Romantic sessions that celebrate your love story',
  active: true,
  store: store
)
Gallery.create(
  name: 'Corporate & Commercial Portraits',
  description: 'Professional imagery for businesses and brands',
  active: false
)
Gallery.create(
  name: 'Product Portraits',
  description: 'Showcase your products with professional, high-quality images',
  active: true,
  store: store
)
Gallery.create(
  name: 'Pet & Animal Portraits',
  description: 'Capturing the personality and spirit of your beloved pets',
  active: true,
  store: store
)
Gallery.create(
  name: 'Event Portraits',
  description: 'Professional coverage for special occasions, corporate gatherings, and milestone celebrations',
  active: true,
  store: store
)
Gallery.create(
  name: 'Graduation & Senior Portraits',
  description: 'Celebrating academic achievements with professional portraits',
  active: true,
  store: store
)
