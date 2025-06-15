require 'rails_helper'

RSpec.describe ShowcasesController, type: :controller do
  describe 'GET #index' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :index, { store_slug: 'store_slug' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let!(:showcase) { create(:showcase, store: store, name: 'about_me') }

      it 'returns a successful response' do
        get :index, params: { store_slug: store.slug }

        expect(response).to have_http_status(:ok)
      end

      it 'assigns and paginates showcases' do
        get :index, params: { store_slug: store.slug }

        expect(controller.instance_variable_get(:@showcases)).to be_present
        expect(controller.instance_variable_get(:@showcases)).to include(showcase)
        expect(controller.instance_variable_get(:@pagy)).to be_present
        expect(controller.instance_variable_get(:@pagy).count).to eq(1)
      end

      context 'when searching by name' do
        let!(:home_showcase) { create(:showcase, store: store, name: 'home') }

        it 'filters showcases by name' do
          get :index, params: { store_slug: store.slug, name: 'home' }

          expect(controller.instance_variable_get(:@showcases)).to include(home_showcase)
          expect(controller.instance_variable_get(:@showcases)).not_to include(showcase)
        end
      end
    end
  end

  describe 'GET #show' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :show, { store_slug: 'store_slug', id: '5' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let!(:home_showcase) { create(:showcase, store: store, name: 'home') }
      let!(:photo1) { create(:photo, imageable: home_showcase, section_key: 'slideshow') }
      let!(:photo2) { create(:photo, imageable: home_showcase, section_key: 'service_card') }

      it 'returns a successful response' do
        get :show, params: { store_slug: store.slug, id: home_showcase.id }

        expect(response).to have_http_status(:ok)
      end

      it 'assigns all instance variables' do
        get :show, params: { store_slug: store.slug, id: home_showcase.id }

        expect(controller.instance_variable_get(:@showcase)).to eq(home_showcase)
        expect(controller.instance_variable_get(:@showcase_photos)).to match(
          {
            'slideshow' => match_array([photo1]),
            'service_card' => match_array([photo2])
          }
        )
        expect(controller.instance_variable_get(:@showcase_sections)).to match_array(%w[service_card slideshow])
      end
    end
  end

  describe 'GET #new' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :new, { store_slug: 'store_slug' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let!(:home_showcase) { create(:showcase, store: store, name: 'home') }

      it 'returns a successful response' do
        get :new, params: { store_slug: store.slug }

        expect(response).to have_http_status(:ok)
      end

      it 'assigns @showcase' do
        get :new, params: { store_slug: store.slug }

        expect(controller.instance_variable_get(:@showcase)).to be_a_new(Showcase)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :post, :create, { store_slug: 'store_slug', gallery_id: '1' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let(:params) do
        {
          store_slug: store.slug,
          showcase: {
            name: name,
            description: 'a collection of photos for the home page.'
          }
        }
      end

      context 'with valid params' do
        let(:name) { 'Home' }

        it 'creates a new showcase record' do
          expect {
            post :create, params: params, as: :turbo_stream
        }.to change { Showcase.count }.by(1)
        expect(flash[:success]).to eq('Showcase successfully created')
        end
      end

      context 'with invalid parameters' do
        let(:name) { nil }

        it 'does not create a showcase record' do
          expect {
            post :create, params: params, as: :turbo_stream
          }.not_to change { Showcase.count }
          expect(flash[:alert]).to eq("Name can't be blank")
        end
      end
    end
  end

  describe 'GET #edit' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :edit, { store_slug: 'store_slug', id: '1' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let!(:home_showcase) { create(:showcase, store: store, name: 'home') }

      it 'returns a successful response' do
        get :edit, params: { store_slug: store.slug, id: home_showcase.id }

        expect(response).to have_http_status(:ok)
      end

      it 'correctly assign the respective @showcase' do
        get :edit, params: { store_slug: store.slug, id: home_showcase.id }

        expect(controller.instance_variable_get(:@showcase)).to eq(home_showcase)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :patch, :update, { store_slug: 'store_slug', id: '1' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let!(:home_showcase) { create(:showcase, store: store, name: 'home') }
      let(:params) do
        {
          store_slug: store.slug,
          id: home_showcase.id,
          case_type: case_type,
          showcase: {
            name: name,
            description: 'a collection of photos for the home page.',
            photo: {
              section_key: 'slideshow',
              image: fixture_file_upload('spec/fixtures/files/test.jpg', 'image/jpeg')
            }
          }
        }
      end

      context 'with valid parameters' do
        let(:name) { 'page' }

        context 'when case_type is info_update' do
          let(:case_type) { 'info_update' }

          it 'updates the showcase name' do
            patch :update, params: params, as: :turbo_stream

            expect(home_showcase.reload.name).to eq('page')
          end
        end

        context 'when case_type is upload_photos' do
          let(:case_type) { 'upload_photos' }

          it 'creates a new photo instance' do
            patch :update, params: params, as: :turbo_stream

            expect(home_showcase.photos.count).to eq(1)
            expect(controller.instance_variable_get(:@showcase_sections)).to eq(['slideshow'])
            expect(controller.instance_variable_get(:@photo)).to eq(home_showcase.photos.order(:id).last)
            expect(flash[:success]).to eq('Showcase successfully updated')
          end
        end
      end

      context 'with invalid parameters' do
        let(:name) { nil }
        let(:case_type) { 'info_update' }

        it 'does not update the showcase name' do
          patch :update, params: params, as: :turbo_stream

          expect(home_showcase.photos.count).to eq(0)
          expect(home_showcase.reload.name).to eq(home_showcase.name)
          expect(flash[:alert]).to eq("Name can't be blank")
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    include_context 'with authenticated user'

    let!(:home_showcase) { create(:showcase, store: store, name: 'home') }

    it 'destroys the showcase' do
      expect {
        delete :destroy, params: { store_slug: store.slug, id: home_showcase.id }, as: :turbo_stream
      }.to change(Showcase, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'DESTROY #bulk_delete' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :delete, :bulk_delete, { store_slug: 'store_slug', id: '1' }
    end

    context 'when user is authenticated' do
      include_context 'with authenticated user'

      let!(:home_showcase) { create(:showcase, store: store, name: 'home', photos_count: 2) }
      let!(:photo1) { create(:photo, imageable: home_showcase, section_key: 'slideshow') }
      let!(:photo2) { create(:photo, imageable: home_showcase, section_key: 'service_card') }
      let(:params) do
        {
          store_slug: store.slug,
          id: home_showcase.id,
          photo_ids: [photo1.id, photo2.id]
        }
      end

      it 'successfully deletes all selected photos' do
        delete :bulk_delete, params: params, as: :turbo_stream

        expect(home_showcase.reload.photos.count).to eq(0)
        expect(home_showcase.reload.photos_count).to eq(0)
        expect(flash[:success]).to eq('Photo(s) deleted successfully from showcase')
      end

      it 'reassigns the @ variables' do
        delete :bulk_delete, params: params, as: :turbo_stream

        expect(controller.instance_variable_get(:@showcase_photos)).to match({})
        expect(controller.instance_variable_get(:@showcase_sections)).to match_array([])
      end
    end
  end
end
