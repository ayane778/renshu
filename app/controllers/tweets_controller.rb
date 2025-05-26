class TweetsController < ApplicationController
  before_action :authenticate_user! #authenticate_user!はgem 'devise'にだけ使用できる処理。Userはモデル名
  def index
    if params[:search].blank?
      @tweets = Tweet.all
    else
      @tweets = Tweet.where("body LIKE ?", "%#{params[:search]}%")
    end
  
    if params[:tag_ids]
      @tweets = []
      params[:tag_ids].each do |key, value|
        @tweets += Tag.find_by(name: key).tweets if value == "1"
      end
      @tweets.uniq!
      @tweets = Kaminari.paginate_array(@tweets).page(params[:page]).per(3)
    else
      @tweets = @tweets.page(params[:page]).per(3)
    end
  
    if params[:tag]
      Tag.create(name: params[:tag])
    end
  end
  


  def new
    @tweet = Tweet.new
  end

  def create #新規投稿の内容を保存するためのアクション「 Tweet.new(tweet_params)」によりtweetモデルの中にある新しいデータの枠が出るようにしている
    tweet = Tweet.new(tweet_params) #privateのtweet_paramsに繋がっていて、pripateの中身をここに代入
    tweet.user_id = current_user.id #5-2のってる
    if tweet.save
      redirect_to :action => "index" #保存できたらindexのページに飛ぶ
    else
      redirect_to :action => "new"
    end
  end

  def show
    @tweet = Tweet.find(params[:id])
    @comments = @tweet.comments
    @comment = Comment.new
  end

  def edit
    @tweet = Tweet.find(params[:id])
  end

  def update #編集用のcreateポディション「 tweet = Tweet.find(params[:id])」のfindのおかげで既にあるデータを持ってきている
    tweet = Tweet.find(params[:id])
    if tweet.update(tweet_params)
      redirect_to :action => "show", :id => tweet.id
    else
      redirect_to :action => "new"
    end
  end

  def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy
    redirect_to action: :index
  end

  private #それより下で定義したメソッドを外から呼び出せないようにするキーワード
  def tweet_params
    params.require(:tweet).permit(:body, :image, tag_ids: []) #tweetはモデル名のなかでもpermitの中身はtweetモデルのなかでもbodyだけとってきてねって意味
  end

end
