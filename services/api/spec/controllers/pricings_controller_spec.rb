require 'rails_helper'

RSpec.describe PricingsController, type: :controller do
  describe 'GET #index' do
    context 'when user is not authenticated' do
      include_examples 'redirects to login', :get, :index, { store_slug: 'store_slug' }
    end

    describe 'when user is authenticated' do
      include_context 'with authenticated user'

      let!(:teacher_galleries) { create(:gallery, store: store, name: 'Teacher Galleries', slug: 'teacher-galleries') }
      let!(:student_galleries) { create(:gallery, store: store, name: 'Student Galleries', slug: 'student-galleries') }

      let!(:package1) { create(:package, gallery: teacher_galleries) }
      let!(:package2) { create(:package, gallery: teacher_galleries) }
      let!(:add_on) { create(:add_on, gallery: teacher_galleries) }

      it 'returns a successful response' do
        get :index, params: { store_slug: store.slug }

        expect(response).to have_http_status(:ok)
      end

      it 'assigns galleries' do
        get :index, params: { store_slug: store.slug }

        expect(controller.instance_variable_get(:@galleries)).to be_present
        expect(controller.instance_variable_get(:@galleries)).to match_array([teacher_galleries, student_galleries])
      end

      context 'when searching galleries by name' do
        it 'filters galleries by name' do
          get :index, params: { store_slug: store.slug, name: 'teacher' }

          expect(controller.instance_variable_get(:@galleries)).to include(teacher_galleries)
          expect(controller.instance_variable_get(:@galleries)).not_to include(student_galleries)
        end
      end
    end
  end
end
