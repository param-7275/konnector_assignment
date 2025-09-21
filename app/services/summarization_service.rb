class SummarizationService

  def initialize(content)
    @content = content
    @client = OpenAI::Client.new(
      access_token: ENV['OPENAI_API_KEY'] || "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"
    )
    end

  def call
    prompt = <<~PROMPT
      Instruction: Summarize the following content in 2-3 lines, friendly tone.
      Content: #{@content}
      Response:
    PROMPT

    response = @client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [{ role: "user", content: prompt }],
        temperature: 0.2,
        max_tokens: 200
      }
    )

    response.dig("choices", 0, "message", "content")&.strip
  rescue => e
    Rails.logger.error("OpenAI API error: #{e.message}")
    Rails.logger.error("OpenAI API error details: #{e.respond_to?(:response) ? e.response[:body] : 'No response body'}")
    nil
  end
end