require 'rails_helper'

RSpec.describe Types::PhotoType, type: :graphql do
  include GraphQL::Testing::Helpers.for(ApiSchema)

  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:file_key).of_type('String') }
  it { is_expected.to have_field(:alt_text).of_type('String') }
  it { is_expected.to have_field(:imageable).of_type('ImageableUnion') }

  describe '#imageable' do
    let(:gallery) { Gallery.first }
    let(:collection) { create(:collection, gallery: gallery) }
    let(:photo) { create(:photo, imageable: collection) }

    it 'returns the imageable object' do
      expect(photo.imageable).to eq(run_graphql_field('Photo.imageable', photo))
    end
  end
end
