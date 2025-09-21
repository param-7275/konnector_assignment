# Voice Transcription & Summarization Web App

A Ruby on Rails application that provides real-time voice transcription and AI-powered summarization using OpenAI's GPT-4o-mini model.

## Features

1. **Real-time Voice Transcription** - Live speech-to-text using Web Speech API
2. **AI-Powered Summarization** - Automatic summary generation using OpenAI GPT-4o-mini
3. **Background Processing** - Non-blocking summarization with Sidekiq
4. **Modern UI** - Clean interface with Stimulus.js for interactivity
5. **RESTful API** - JSON endpoints for transcription management

## Quick Start

### Prerequisites
- Ruby 3.3.4
- Rails 7.1.5+
- Chrome browser (for Web Speech API)
- OpenAI API key

### Installation

1. **Install dependencies**
   bundle install

2. **Setup environment variables**
    Create .env file and set constant. I am not able to push .env file so we need to create .env file and add correct OPENAI_API_KEY.

    OPENAI_API_KEY=sk-your-openai-api-key-here > .env

3. **Setup database**
   rails db:create db:migrate

4. **Start the application**
   # Terminal 1: Start Rails server
   bundle exec rails server
   
   # Terminal 2: Start Sidekiq server
   bundle exec sidekiq (check redis is installed or not if not first start the redis server)

5. **Open in browser**
   http://localhost:3000

## How to Use

1. **Start Recording**: Click "Start Listening" button
2. **Speak**: Your voice will be transcribed in real-time
3. **Stop Recording**: Click "Stop Listening" button
4. **View Results**: 
   - Full transcription appears immediately
   - AI summary appears after processing (2-5 seconds)
5. **View All Transcriptions**: Click "Show All Transcriptions" to see all transcriptions

## Architecture

### Frontend
1. **Stimulus.js** - JavaScript framework for interactivity
2. **Web Speech API** - Browser-based speech recognition
3. **Real-time Updates** - Live transcription display

### Backend
1. **Ruby 3.3.4** - Programming language
2. **Rails 7.1.5** - Web framework
3. **SQLite** - Database for storing transcriptions
4. **Sidekiq** - Background job processing
5. **OpenAI API** - AI summarization service

## API Endpoints

 Method           Endpoint                  Description 

 GET        `localhost:3000`           Main transcription page 

 POST       `/transcriptions`          Create new transcription 
 GET        `/transcriptions/:id`      Get a transcription with id 
 GET        `/transcriptions`          List all transcriptions 
 DELETE     `/transcriptions/:id`      Delete a transcription 

 GET        `/sidekiq`                 Sidekiq web interface 

## Testing

 **Run all tests**
    bundle exec rspec

 **Run specific test**
    bundle exec rspec spec/requests/transcriptions_spec.rb


### Background Jobs
  **Queue**: `default`
  **Adapter**: Sidekiq
  **Web UI**: http://localhost:3000/sidekiq


### Common Issues

1. **"Browser does not support Web Speech API"**
   - Use Chrome browser and allow microphone permissions

2. **"If Summary not ready"**
   - Check Sidekiq is running
   - Verify OpenAI API key
   - Check Sidekiq logs

### Debug Mode

# Check database
    bundle exec rails c or rails c


**Note**: This application requires Chrome browser and microphone permissions for optimal functionality.
