class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    question = Question.find(params[:question_id])
    @subscription = Subscription.create(question: question, user: current_user)
  end

  def destroy
    #@subscription = Subscription.find(params[:id])
    @subscription = current_user.subscriptions.find(params[:id])
    @subscription.destroy
  end

  private

  def question
    @question ||= subscription.question
  end

  def subscription
    @subscription ||= Subscription.find(params[:id])
  end

  helper_method :question
end
