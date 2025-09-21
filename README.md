# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# Transcribe Assignment (Rails)

## Setup
1. Install gems: `bundle install`
2. Set OPENAI_API_KEY: `export OPENAI_API_KEY="sk-..."`
3. DB: `rails db:create db:migrate`
4. Run server: `bin/rails server`
5. Open: http://localhost:3000/transcribe (use Chrome)

## Tests
`bundle exec rspec`

## Notes
- Uses Web Speech API (Chrome) for live transcription on client.
- Backend uses OpenAI (`openai` gem) for summarization.
- To use background worker, configure ActiveJob adapter / start sidekiq.
