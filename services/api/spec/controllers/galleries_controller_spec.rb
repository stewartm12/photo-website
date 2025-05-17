require 'rails_helper'

RSpec.describe GalleriesController, type: :controller do
  describe 'GET #index' do
    context 'when user is not authenticated' do
      it 'redirects to the login page' do
        get :index, params: { store_slug: 'store_slug' }

        expect(response).to redirect_to(new_session_path)
      end
    end

    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:store) { create(:store, owner: user) }
      let(:session) { create(:session, user: user) }
      let!(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }

      before do
        create(:store_membership, store: store, user: user)
        allow(controller).to receive(:resume_session).and_return(session)
        allow(Current).to receive(:user).and_return(user)
      end

      it 'returns a successful response' do
        get :index, params: { store_slug: store.slug }

        expect(response).to have_http_status(:ok)
      end

      it 'assigns and paginates galleries' do
        get :index, params: { store_slug: store.slug }

        expect(controller.instance_variable_get(:@galleries)).to be_present
        expect(controller.instance_variable_get(:@galleries)).to include(gallery)
        expect(controller.instance_variable_get(:@pagy)).to be_present
        expect(controller.instance_variable_get(:@pagy).count).to eq(1)
      end

      context 'when searching galleries by name' do
        let(:empty_gallery) { create(:gallery, store: store, name: 'empty gallery', slug: 'empty-gallery') }
        let(:full_gallery) { create(:gallery, store: store, name: 'full gallery', slug: 'full-gallery') }

        it 'filters galleries by name' do
          get :index, params: { store_slug: store.slug, name: 'empty' }

          expect(controller.instance_variable_get(:@galleries)).to include(empty_gallery)
          expect(controller.instance_variable_get(:@galleries)).not_to include(full_gallery)
        end
      end

      context 'when searching galleries by status' do
        let(:active_gallery) { create(:gallery, store: store, name: 'active gallery', slug: 'active-gallery', active: true) }
        let(:inactive_gallery) { create(:gallery, store: store, name: 'inactive gallery', slug: 'inactive-gallery', active: false) }

        it 'filters galleries by status' do
          get :index, params: { store_slug: store.slug, active: true }

          expect(controller.instance_variable_get(:@galleries)).to include(active_gallery)
          expect(controller.instance_variable_get(:@galleries)).not_to include(inactive_gallery)
        end
      end

      context 'when sorting galleries' do
        let!(:gallery_1) { create(:gallery, store: store, name: 'first gallery', updated_at: 2.days.ago) }
        let!(:gallery_2) { create(:gallery, store: store, name: 'second gallery', updated_at: 1.day.ago) }

        it 'sorts galleries by name in ascending order' do
          get :index, params: { store_slug: store.slug, sort: 'name', order: 'asc' }

          expect(controller.instance_variable_get(:@galleries)).to eq([gallery_1, gallery, gallery_2])
        end

        it 'sorts galleries by updated_at in descending order' do
          get :index, params: { store_slug: store.slug, sort: 'updated_at', order: 'desc' }

          expect(controller.instance_variable_get(:@galleries)).to eq([gallery, gallery_2, gallery_1])
        end
      end
    end
  end

  describe 'GET #show' do
    let(:user) { create(:user) }
    let(:store) { create(:store, owner: user) }
    let!(:store_membership) { create(:store_membership, store: store, user: user) }
    let(:session) { create(:session, user: user) }
    let(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }

    before do
      allow(controller).to receive(:resume_session).and_return(session)
      allow(Current).to receive(:user).and_return(user)
    end

    it 'returns a successful response' do
      get :show, params: { store_slug: store.slug, id: gallery.id }

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #new' do
    context 'when user is not authenticated' do
      it 'redirects to the login page' do
        get :index, params: { store_slug: 'store_slug' }

        expect(response).to redirect_to(new_session_path)
      end
    end

    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:store) { create(:store, owner: user) }
      let!(:store_membership) { create(:store_membership, store: store, user: user) }
      let(:session) { create(:session, user: user) }
      let(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }

      before do
        allow(controller).to receive(:resume_session).and_return(session)
        allow(Current).to receive(:user).and_return(user)
      end

      it 'returns a successful response' do
        get :show, params: { store_slug: store.slug, id: gallery.id }

        expect(response).to have_http_status(:ok)
      end

      it 'assigns @gallery' do
        get :new, params: { store_slug: store.slug, id: gallery.id }

        expect(controller.instance_variable_get(:@gallery)).to be_a_new(Gallery)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is not authenticated' do
      it 'redirects to the login page' do
        get :index, params: { store_slug: 'store_slug' }

        expect(response).to redirect_to(new_session_path)
      end
    end

    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:store) { create(:store, owner: user) }
      let!(:store_membership) { create(:store_membership, store: store, user: user) }
      let(:session) { create(:session, user: user) }

      before do
        allow(controller).to receive(:resume_session).and_return(session)
        allow(Current).to receive(:user).and_return(user)
      end

      context 'with valid params' do
        let(:params) do
          {
            store_slug: store.slug,
            gallery: {
              name: 'the very first test gallery',
              description: 'this is a description',
              active: false,
              photo_attributes: { image: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/files/test.jpg") }
            }
          }
        end

        it 'creates a new gallery attached with the image' do
          expect {
            post :create, params: params
          }.to change { Gallery.count }.by(1)

          expect(Gallery.last.photo.image.attached?).to eq(true)
        end

        it 'redirects with a successful save message' do
          post :create, params: params

          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(store_galleries_path(store))
          expect(flash[:success]).to include('Gallery created successfully.')
        end
      end

      context 'with invalid params' do
        let(:params) do
          {
            store_slug: store.slug,
            gallery: {
              name: test_name,
              description: 'this is a description',
              active: false,
              photo_attributes: test_image
            }
          }
        end

        context 'with invalid gallery parameters' do
          let(:test_name) { '' }
          let(:test_image) do
            {
              image: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/files/test.jpg")
            }
          end

          it 'returns an error' do
            expect {
            post :create, params: params, as: :turbo_stream
          }.not_to change { Gallery.count }

            expect(flash[:alert]).to include("Name can't be blank")
          end
        end

        context 'with invalid image type' do
          let(:test_name) { 'This is correct test title' }
          let(:test_image) do
            {
              image: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/files/fail_test.pdf")
            }
          end

          it 'returns an error' do
            expect {
            post :create, params: params, as: :turbo_stream
          }.not_to change { Gallery.count }

            expect(flash[:alert]).to include('Photo image must be a JPEG, PNG, WEBP, or AVIF')
          end
        end

        context 'with no image' do
          let(:test_name) { 'This is correct test title' }
          let(:test_image) { { image: nil } }

          it 'returns an error' do
            expect {
            post :create, params: params, as: :turbo_stream
          }.not_to change { Gallery.count }

            expect(flash[:alert]).to include('Please upload an image.')
          end
        end
      end
    end
  end

  describe 'GET #edit' do
    context 'when user is not authenticated' do
      it 'redirects to the login page' do
        get :index, params: { store_slug: 'store_slug' }

        expect(response).to redirect_to(new_session_path)
      end
    end

    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:store) { create(:store, owner: user) }
      let(:session) { create(:session, user: user) }
      let!(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }

      before do
        create(:store_membership, store: store, user: user)
        allow(controller).to receive(:resume_session).and_return(session)
        allow(Current).to receive(:user).and_return(user)
      end

      it 'returns a successful response' do
        get :edit, params: { store_slug: store.slug, id: gallery.id }

        expect(response).to have_http_status(:ok)
      end

      it 'correctly assign the respective @ varirables' do
        get :edit, params: { store_slug: store.slug, id: gallery.id }

        expect(controller.instance_variable_get(:@gallery)).to eq(gallery)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is not authenticated' do
      it 'redirects to the login page' do
        get :index, params: { store_slug: 'store_slug' }

        expect(response).to redirect_to(new_session_path)
      end
    end

    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:store) { create(:store, owner: user) }
      let(:session) { create(:session, user: user) }
      let(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }
      let!(:photo) do
        create(
          :photo,
          imageable: gallery,
          image: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/files/test2.jpg")
        )
      end

      before do
        create(:store_membership, store: store, user: user)
        allow(controller).to receive(:resume_session).and_return(session)
        allow(Current).to receive(:user).and_return(user)
      end

      context 'with valid params' do
        let(:image_file) { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/files/test.jpg") }
        let(:params) do
          {
            store_slug: store.slug,
            id: gallery.id,
            gallery: {
              name: 'Testing update',
              photo_attributes: { image: image_file }
            }
          }
        end

        it 'successfully updates the gallery' do
          patch :update, params: params

          expect(gallery.reload.name).to eq('Testing Update')
          expect(response).to redirect_to(store_galleries_path(store))
          expect(flash[:success]).to include('Gallery updated successfully.')
        end

        it "successfully updates the gallery's photo" do
          patch :update, params: params

          expect(photo.reload.image.filename.to_s).to eq('test.jpg')
        end
      end

      context 'with invalid params' do
        let(:params) do
          {
            store_slug: store.slug,
            id: gallery.id,
            gallery: { name: '' }
          }
        end

        it 'does not update the gallery' do
          patch :update, params: params, as: :turbo_stream

          expect(gallery.reload.name).to eq('Gallery 1')
          expect(flash[:alert]).to include("Name can't be blank")
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:store) { create(:store, owner: user) }
    let(:session) { create(:session, user: user) }
    let!(:gallery) { create(:gallery, store: store, name: 'gallery 1', slug: 'gallery-1') }

    before do
      create(:store_membership, store: store, user: user)
      allow(controller).to receive(:resume_session).and_return(session)
      allow(Current).to receive(:user).and_return(user)
    end

    it 'destroys the gallery' do
      expect {
        delete :destroy, params: { store_slug: store.slug, id: gallery.id }, as: :turbo_stream
      }.to change(Gallery, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end
