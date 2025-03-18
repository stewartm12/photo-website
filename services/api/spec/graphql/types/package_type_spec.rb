require 'rails_helper'

RSpec.describe Types::PackageType, type: :graphql do
  include GraphQL::Testing::Helpers.for(ApiSchema)

  subject { described_class }

  describe 'fields' do
    it { is_expected.to have_field(:id).of_type('ID!') }
    it { is_expected.to have_field(:name).of_type('String!') }
    it { is_expected.to have_field(:price).of_type('String!') }
    it { is_expected.to have_field(:edited_images).of_type('Int') }
    it { is_expected.to have_field(:outfit_change).of_type('Boolean') }
    it { is_expected.to have_field(:duration).of_type('Int') }
    it { is_expected.to have_field(:features).of_type('[String!]') }
    it { is_expected.to have_field(:popular).of_type('Boolean') }
    it { is_expected.to have_field(:gallery).of_type('Gallery!') }

    describe '#price' do
      let(:gallery) { Gallery.first }
      let(:package) { create(:package, gallery: gallery) }

      it 'returns the package price' do
        expect(package.price.to_s).to eq(run_graphql_field('Package.price', package))
      end
    end
  end
end
