class SegmentsController < ApplicationController
  before_action :load_segment, only: [:show]
  before_action :load_segments
  #before_action :representative_restrictions, only: [:show]

  def index
  end

  def show
    authorize! :read, @segment
    load_candidacies
    respond_to do |format|
      format.html { render :index }
      format.js
    end
  end

  def new
    @segment = Segment.new
  end

  def create
    @segment = Segment.new(segment_params)
    @group = @segment.build_group(name: params[:segment][:name])
    @segment.save
    render :index
  end

  private

  def load_segment
    @segment = Segment.find(params[:id])
  end

  def load_segments
    @q = Segment.ransack(params[:q])
    @segments = @q.result(distinct: true)
    if !@segment
      @segments = @segments.where(parent_id: nil)
    end
  end

  def load_candidacies
    @political_candidacies_loader = PoliticalCandidaciesLoader.new(@segment)
  end

  def segment_params
    params.require(:segment).permit(:name, :parent_id)
  end

  def representative_restrictions
    
  end
end
