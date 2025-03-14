require 'rails_helper'

RSpec.describe Types::CollectionType, type: :graphql do
  subject { described_class }

  describe 'fields' do
    it { is_expected.to have_field(:id).of_type('ID!') }
    it { is_expected.to have_field(:name).of_type('String!') }
    it { is_expected.to have_field(:gallery).of_type('Gallery!') }
    it { is_expected.to have_field(:photos).of_type('[Photo!]') }
  end
end
