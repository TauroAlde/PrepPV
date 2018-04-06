class PrepProcessesController < ApplicationController
  before_action :load_user
  before_action :load_segment
  before_action :load_segment_message
  before_action :load_prep_process_machine
  before_action :load_message_history

  def new
  end

  def next
    @prep_process_machine.next!
    if @prep_process_machine.errors.empty?
      flash[:notice] = "¡Se avanzo al siguiente paso!"
    else
      flash[:warning] = @prep_process_machine.errors.full_messages.last
    end
    render :new
  end

  def previous
    @prep_process_machine.previous!
  end

  private

  def load_message_history
    @previous_messages = current_user.segment_messages.where(segment: @segment)
  end

  def load_prep_process_machine
    @prep_process_machine = PrepProcessMachine.new(segment: @segment, user: @user)
    @prep_process_machine.find_or_create
  end

  def load_segment_message
    @segment_message = SegmentMessage.new(segment: @segment)
  end

  def load_user
    @user = params[:user_id] ? User.find(params[:user_id]) : current_user
  end

  def load_segment
    @segment = Segment.find(params[:segment_id])
  end
end
