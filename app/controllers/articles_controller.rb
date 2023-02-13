class ArticlesController < ApplicationController
  include ActionController::Cookies
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    session[:page_views] ||= 0
    session[:page_views] += 1
    if session[:page_views] <= 3 
      article = Article.find(params[:id])
      render json: article
    elsif session[:page_views] > 3
      render json: { error: "Maximum pageview limit reached" }, status: :unauthorized
    end

  end


  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

  # def article_view_count
  #   session[:article_count] ||= 0
  #   session[:article_count] += 1 if session[:article_count] < 3
  #   render json:  if session[:article_count] == 3
  # end

end
