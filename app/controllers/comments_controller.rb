class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [:edit, :update, :destroy]

  # cоздаём комментарий в контексте поста: params[:post_id]
  def create
    if params[:post_id]
      commentable = Post.find(params[:post_id])
    else
      return render_not_found
    end

    @comment = commentable.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_back fallback_location: commentable, notice: "Комментарий добавлен"
    else
      redirect_back fallback_location: commentable, alert: "Ошибка при добавлении комментария"
    end
  end

  def edit
  end

  def update
    if @comment.user != current_user && !current_user.admin?
      redirect_back fallback_location: root_path, alert: "Нет прав"
    elsif @comment.update(comment_params)
      redirect_back fallback_location: @comment.commentable, notice: "Комментарий обновлён"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @comment.user == current_user || current_user.admin?
      @comment.destroy
      redirect_back fallback_location: root_path, notice: "Комментарий удалён"
    else
      redirect_back fallback_location: root_path, alert: "Нет прав"
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :parent_comment_id)
  end
end