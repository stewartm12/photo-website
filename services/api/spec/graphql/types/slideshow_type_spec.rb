require 'rails_helper'

RSpec.describe Types::SlideshowType, type: :graphql do
  subject { described_class }

  describe 'fields' do
    it { is_expected.to have_field(:id).of_type('ID!') }
    it { is_expected.to have_field(:name).of_type('String!') }
    it { is_expected.to have_field(:description).of_type('String') }
    it { is_expected.to have_field(:active).of_type('Boolean!') }
    it { is_expected.to have_field(:photos).of_type('[Photo!]') }
  end
end
