class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @question = Question.all
  end

  def show
  end

  def new
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
