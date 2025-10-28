class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource

  def index
    @articles = Article.all
  end

  def show; end

  def new; end

  def create
    @article.user = current_user
    if @article.save
      redirect_to @article, notice: 'Статья успешно опубликована.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: 'Статья обновлена.'
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: 'Статья удалена.'
  end

  private

  def article_params
    params.require(:article).permit(:title, :content)
  end
end

#ищем статью по тегу
def tagged
  if params[:tag].present?
    @articles = Article.tagged_with(params[:tag])
  else
    @articles = Article.all
  end
end