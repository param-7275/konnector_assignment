require 'rails_helper'

RSpec.describe Transcription, type: :model do
  describe 'validations' do
    it 'validates presence of content' do
      transcription = Transcription.new(content: nil)
      expect(transcription).not_to be_valid
      expect(transcription.errors[:content]).to include("can't be blank")
    end

    it 'validates inclusion of status' do
      transcription = Transcription.new(content: "test", status: "invalid")
      expect(transcription).not_to be_valid
      expect(transcription.errors[:status]).to include("is not included in the list")
    end

    it 'accepts valid statuses' do
      %w[pending processing done failed].each do |status|
        transcription = Transcription.new(content: "test", status: status)
        expect(transcription).to be_valid
      end
    end
  end

  describe 'default values' do
    it 'sets default status to pending' do
      transcription = Transcription.create!(content: "test content")
      expect(transcription.status).to eq("pending")
    end
  end
end
