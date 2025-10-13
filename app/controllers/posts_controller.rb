class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :search, :popular]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :toggle_like, :toggle_bookmark]

  def index
    @posts = Post.includes(:user, :tags).order(created_at: :desc).page(params[:page])
  end

  def feed

    @posts = Post.joins(:user).where(user_id: current_user.following_ids).order(created_at: :desc).page(params[:page])
    render :index
  end

  def popular
    @posts = Post.left_joins(:likes).group(:id).order('COUNT(likes.id) DESC').limit(20)
    render :index
  end

  def search
    q = params[:q].to_s.strip
    @posts = if q.blank?
      Post.none
    else
      Post.where("title ILIKE ? OR body ILIKE ?", "%#{q}%", "%#{q}%")
    end
    render :index
  end

  def show
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: "Пост создан"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize_owner!
  end

  def update
    authorize_owner!
    if @post.update(post_params)
      redirect_to @post, notice: "Пост обновлён"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize_owner!
    @post.destroy
    redirect_to posts_path, notice: "Пост удалён"
  end

  def toggle_like
    like = current_user.likes.find_by(post: @post)
    if like
      like.destroy
      render json: { liked: false }
    else
      current_user.likes.create!(post: @post)
      render json: { liked: true }
    end
  end

  def toggle_bookmark
    fav = current_user.favorites.find_by(post: @post)
    if fav
      fav.destroy
      render json: { bookmarked: false }
    else
      current_user.favorites.create!(post: @post)
      render json: { bookmarked: true }
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_owner!
    unless @post.user == current_user || current_user.admin?
      redirect_to @post, alert: "Нет прав", status: :forbidden
    end
  end

  def post_params
    params.require(:post).permit(:title, :body, :post_image, tag_ids: [])
  end
end