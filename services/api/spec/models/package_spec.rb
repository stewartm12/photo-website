require 'rails_helper'

RSpec.describe Package, type: :model do
  let(:gallery) { Gallery.first }
  let!(:package) { create(:package, gallery: gallery) }

  describe 'associations' do
    it { should belong_to(:gallery) }
    it { should have_many(:appointments) }
  end

  describe 'associations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:gallery) }
  end

  describe '#formatted_duration' do
    subject { described_class.new(duration: duration) }

    context 'when duration is only in minutes' do
      let(:duration) { 30 }

      it 'returns only minutes' do
        expect(subject.formatted_duration).to eq('30 minutes')
      end
    end

    context 'when duration is only in hours' do
      let(:duration) { 120 }

      it 'returns only hours' do
        expect(subject.formatted_duration).to eq('2 hours')
      end
    end

    context 'when duration is hours and minutes' do
      let(:duration) { 135 }
      it 'returns hours and minutes' do
        expect(subject.formatted_duration).to eq('2 hours 15 minutes')
      end
    end
  end
end
