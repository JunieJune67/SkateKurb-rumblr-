require "sinatra/activerecord"
require "sinatra"
require "sinatra/flash"

enable :sessions

# if ENV['RACK_ENV'] == 'development'
#     set :database, {adapter: "sqlite3", database: "database.sqlite3"}
# else
#     ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
# end

set :database, {adapter: "sqlite3", database: "database.sqlite3"}

class User < ActiveRecord::Base
  has_many :journals
end

class Journal < ActiveRecord::Base
 belongs_to :user
end 

get '/' do
    p session
    erb :home
end


  
  post "/" do 
    user = User.find_by(email: params['email']) 
    if user != nil 
      if user.password == params['password'] 
        session[:user_id] = user.id
        redirect "/users/skaters/#{user.id}"
      else 
        redirect "/users/signup"
      end
    end
  end

  get '/users/skaters/:id' do
    @user = User.find(params[:id])
    @journals = @user.journals
    if session[:user_id]
    erb :"/users/skaters"
  end
end

get '/users/signup' do
 erb :"/users/signup"
end

post '/signup' do
   @user = User.new(first_name: params[:first_name], username: params[:username], last_name: params[:last_name], email: params[:email], birthday: params[:birthday], password: params[:password])
   @user.save
   session['user_id'] = @user.id
   flash[:info] = "Account Created! Welcome to Skate Kurb!"
    redirect "/allskaters"
  # "/users/skaters/#{@user.id}"
end



get "/allskaters" do
   @journal = Journal.all
    session['user_id'] == nil
    erb :"/allskaters"
  end
  

post '/articles/journalentries' do 
    @user = User.find_by(id: session[:user_id])
    @journal = Journals.new(title: params[:title], subcategory: params[:subcategory], text: params[:text], user_id: session[:user_id])
    @journal.save
    flash[:info] = "Journal posted!"
    redirect "/users/skaters/#{@user.id}"
    
end

delete "/trashjournal/" do
@user = User.find(id: session[:user_id])
@journal = Journals.find(params['id'])
if journal.user_id == session[:user_id]
@journal.destroy
flash[:info] = "You have deleted your post"
redirect "/users/skaters/#{@user.id}"
else
  redirect "/users/skaters/#{@user.id}"
end
end

get '/trashjournal/' do
  erb :"/users/skaters"
end


post "/trashuser/:id" do
  @user =  User.find(params["id"])
  @user.destroy
  session["user_id"] = nil
  redirect "/"
end

get '/logout' do
    session["user_id"] = nil
    redirect "/"
  end




  


  







