require "openai"

OPENAI_CLIENT = OpenAI::Client.new(
  access_token: ENV["OPENAI_API_KEY"],
  organization_id: ENV["OPENAI_ORG_ID"]
)