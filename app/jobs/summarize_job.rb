class SummarizeJob < ApplicationJob
  queue_as :default

  def perform(transcription_id)
    transcription = Transcription.find_by(id: transcription_id)
    unless transcription
      Rails.logger.error("Transcription not found: ##{transcription_id}")
      return
    end

    Rails.logger.info("SummarizeJob started for transcription ##{transcription_id}")
    transcription_content = transcription.content
    summary = SummarizationService.new(transcription_content).call

    if summary.present?
      transcription.update!(summary: summary, status: "done")
      Rails.logger.info("SummarizeJob completed for transcription ##{transcription_id}")
    else
      transcription.update!(status: "failed")
      Rails.logger.error("SummarizeJob failed for transcription ##{transcription_id}: empty summary")
    end
    
  rescue => e
    transcription&.update!(status: "failed")
    Rails.logger.error("SummarizeJob exception for transcription ##{transcription_id}: #{e.message}")
  end
end
