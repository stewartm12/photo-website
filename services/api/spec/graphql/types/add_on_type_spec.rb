require 'rails_helper'

RSpec.describe Types::AddOnType, type: :graphql do
  subject { described_class }

  describe 'fields' do
    it { is_expected.to have_field(:id).of_type('ID!') }
    it { is_expected.to have_field(:name).of_type('String!') }
    it { is_expected.to have_field(:price).of_type('String!') }
    it { is_expected.to have_field(:limited).of_type('Boolean') }
    it { is_expected.to have_field(:gallery).of_type('Gallery!') }
  end
end
