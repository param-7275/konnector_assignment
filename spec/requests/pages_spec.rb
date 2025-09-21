require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET#transcribe" do
    it "returns http success" do
      get "/transcribe"
      expect(response).to have_http_status(:ok)
    end
  end
end
