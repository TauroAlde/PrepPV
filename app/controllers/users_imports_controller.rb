class UsersImportsController < ApplicationController
  before_action :load_segment

  def new
    @segment_user_import = SegmentUserImport.new(
      segment: @segment,
      uploader: current_user
    )
  end

  def create
    @segment_user_import = SegmentUserImport.create(
      status: SegmentUserImport::INCOMPLETE,
      segment: @segment,
      uploader: current_user,
      file: import_user_params[:file]
    )

    @user_import_manager = UserImportManager.new(@segment_user_import)
    @user_import_manager.import!
    if @user_import_manager.errors.present?
      flash[:warning] = @user_import_manager.errors.join(", ")
      render :new
    end
  end

  private

  def load_segment
    @segment = Segment.find(params[:segment_id])
  end

  def import_user_params
    params.require(:segment_user_import).permit(:file)
  end
end
