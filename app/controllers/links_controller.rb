class LinksController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def destroy
    @link = Link.find(params[:id])

    if current_user.author_of?(@link.linkable)
      @link.destroy
      flash[:notice] = 'Link was deleted.'
    else
      head :forbidden
    end
  end
end
