require 'rails_helper'

RSpec.describe "Transcriptions API", type: :request do
  before { ActiveJob::Base.queue_adapter = :test }

  let!(:transcription) { Transcription.create!(content: "Hi", summary: "Short summary") }
  let(:client) { instance_double(OpenAI::Client) }
  let(:fake_resp) do
    { "choices" => [{ "message" => { "content" => "Short summary for the test" } }] }
  end

  before do
    allow(OpenAI::Client).to receive(:new).and_return(client)
    allow(client).to receive(:chat).and_return(fake_resp)
  end

  it 'creates transcription and returns summary' do
    perform_enqueued_jobs do
      post "/transcriptions",
        params: { transcription: { content: "Hello this is a test content" } }.to_json,
        headers: { "CONTENT_TYPE" => "application/json" }
    end

    expect(response).to have_http_status(:created)
    transcription = JSON.parse(response.body)
    expect(transcription["content"]).to include("Hello this is a test content")
  end

  it 'shows a transcription by id' do
    get "/transcriptions/#{transcription.id}"
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body["data"]["attributes"]["summary"]).to eq("Short summary")
  end

  it 'shows all transcriptions' do
    get "/transcriptions", as: :json
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body).to be_an(Array)
    expect(body.first["summary"]).to include("Short summary")
  end

  it "delete a transcription" do
    delete "/transcriptions/#{transcription.id}"
    expect(response).to have_http_status(:found)
    expect(Transcription.exists?(transcription.id)).to be_falsey
  end
end
