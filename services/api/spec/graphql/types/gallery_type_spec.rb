require 'rails_helper'

RSpec.describe Types::GalleryType, type: :graphql do
  subject { described_class }

  describe 'fields' do
    it { is_expected.to have_field(:id).of_type('ID!') }
    it { is_expected.to have_field(:name).of_type('String!') }
    it { is_expected.to have_field(:description).of_type('String') }
    it { is_expected.to have_field(:slug).of_type('String!') }
    it { is_expected.to have_field(:photo).of_type('Photo') }
    it { is_expected.to have_field(:collections).of_type('[Collection!]') }
  end
end
