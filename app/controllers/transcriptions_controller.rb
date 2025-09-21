class TranscriptionsController < ApplicationController

  # def index
  #   @transcriptions = Transcription.all
  #   render :index, status: :ok
  # end
  
  def index
    @transcriptions = Transcription.all

    respond_to do |format|
      format.html
      format.json do
        render json: @transcriptions.as_json(only: [:id, :content, :summary, :status, :created_at, :updated_at])
      end
    end
  end


  def create
    @transcription = Transcription.new(transcription_params)
    @transcription.status = "processing"
    if @transcription.save
      SummarizeJob.perform_later(@transcription.id)
      render json: @transcription, status: 201
    else
      render json: { errors: @transcription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @transcription = Transcription.find_by(id: params[:id])
    if @transcription
      render json: {
        data: {
          id: @transcription.id,
          attributes: {
            content: @transcription.content,
            summary: @transcription.summary,
            status: @transcription.status
          }
        }
      }, status: :ok
    else
      render json: { error: "Transcription not found" }, status: :not_found
    end
  end


  def destroy
    @transcription = Transcription.find(params[:id])
    @transcription.destroy
    redirect_to transcriptions_path, notice: "Transcription deleted successfully."
  end

  private

  def transcription_params
    params.require(:transcription).permit(:content) 
  end
end

