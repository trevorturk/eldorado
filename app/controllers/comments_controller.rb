class CommentsController < ApplicationController
  
  before_filter :redirect_home, :except => [:create]
  before_filter :require_login, :except => [:index, :show]
  before_filter :can_edit, :only => [:edit, :update, :destroy]
  
  def index
  end
  
  def show
  end
  
  def new
  end
  
  def edit
  end
  
  def create
    @comment = current_user.comments.build(params[:comment])
    if @comment.save
      redirect_to polymorphic_url(@comment.resource) + '#c' + @comment.id.to_s
    else
      redirect_to polymorphic_url(@comment.resource) + '#comments' + @comment.id.to_s
    end
  end
  
  def update
  end
  
  def destroy
  end
end
