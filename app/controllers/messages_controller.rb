class MessagesController < ApplicationController
  before_action :set_message, only: [:update]

  def create
    @message = Message.new(message_params)
    if @message.save
      notify_third_parties(@message)
      render json: @message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  def update
    if @message.update(message_params)
      notify_third_parties(@message)
      render json: @message, status: :ok
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  private

  def set_message
    @message = Message.find_by(id: params[:id])
  end

  def message_params
    params.require(:message).permit(:name, :data)
  end

  def notify_third_parties(message)
    ThirdPartyNotifier.notify(message)
  end
end
