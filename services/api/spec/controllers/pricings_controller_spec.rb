require 'rails_helper'

RSpec.describe PricingsController, type: :controller do
  describe 'GET #index' do
    context 'when user is not authenticated' do
      it 'redirects to the login page' do
        get :index, params: { store_slug: 'store_slug' }

        expect(response).to redirect_to(new_session_path)
      end
    end

    describe 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:store) { create(:store, owner: user) }
      let(:session) { create(:session, user: user) }
      let!(:teacher_galleries) { create(:gallery, store: store, name: 'Teacher Galleries', slug: 'teacher-galleries') }
      let!(:student_galleries) { create(:gallery, store: store, name: 'Student Galleries', slug: 'student-galleries') }

      let!(:package1) { create(:package, gallery: teacher_galleries) }
      let!(:package2) { create(:package, gallery: teacher_galleries) }
      let!(:add_on) { create(:add_on, gallery: teacher_galleries) }

      before do
        create(:store_membership, store: store, user: user)
        allow(controller).to receive(:resume_session).and_return(session)
        allow(Current).to receive(:user).and_return(user)
      end

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

  describe 'GET #show' do
  end

  describe 'GET #edit' do
  end

  describe 'GET #new' do
  end

  describe 'POST #create' do
  end

  describe 'PATCH #update' do
  end

  describe 'DELETE #destroy' do
  end
end
