class Transcription < ApplicationRecord
  STATUSES = %w[pending processing done failed].freeze
  validates :content, presence: true
  validates :status, inclusion: { in: STATUSES }
end
