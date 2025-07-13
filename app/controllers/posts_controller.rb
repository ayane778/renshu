class PostsController < ApplicationController
  before_action :authenticate_user! #authenticate_user!はgem 'devise'にだけ使用できる処理。Userはモデル名
  before_action :if_not_admin, except: [:show, :index]
  def index
      start_date = params.fetch(:start_date, Date.today).to_date
      @events = Post.where('start_time <= ? AND (end_time >= ? OR end_time IS NULL)', start_date.end_of_month.end_of_week, start_date.beginning_of_month.beginning_of_week)

  end

  def new
      @post = Post.new
  end

  def create
      post = Post.new(post_params)
      if post.save
          redirect_to :action => "index"
      else
          redirect_to :action => "new"
      end
  end
  def show
      @post = Post.find(params[:id])
  end

  def edit
      @post = Post.find(params[:id])
  end

  def update
      post = Post.find(params[:id])
      if post.update(post_params)
          redirect_to :action => "show", :id => post.id
      else
          redirect_to :action => "new"
      end
  end

  def destroy
      post = Post.find(params[:id])
      post.destroy
      redirect_to action: :index
  end

  private
  def if_not_admin
        redirect_to root_path unless current_user.email == ENV['ADMIN_EMAIL']
     end
  def post_params
      params.require(:post).permit(:title,:start_time,:end_time)
  end

end
