class PostsController < ApplicationController
  def index
    @posts = Post.includes(:tags).all
  end

  def new
    @post = Post.new
    @tags = Tag.all
    Rails.logger.debug "TAGS: #{@tags.pluck(:name)}"
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to user_path(current_user), notice: "Пост создан"
    else
      @tags = Tag.all
      render :new
    end
  end

  def destroy
  @post = Post.find(params[:id])

  @post.destroy

  redirect_to user_path(current_user), notice: "Пост удалён"
  end

  private

  def post_params
  params.require(:post).permit(
    :title,
    :body,
    :image,
    tag_ids: []
  )
  end
end
