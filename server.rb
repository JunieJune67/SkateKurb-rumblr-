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
  has_many :journals, dependent: :destroy
end

class Journal < ActiveRecord::Base
 belongs_to :user

end 

get "/" do
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

get '/users/skaters' do
  @user = User.find(session[:user_id])
  @journals = @user.journals
  erb :"/users/skaters"
end

get '/users/skaters/:id' do
  @user = User.find(params[:id])
  @journals = @user.journals
  if session[:user_id]
    erb :"/users/skaters"
  end
end

get "/logout" do

  session["user_id"] = nil
  redirect "/"
end

get '/signup' do
  erb :"/users/signup"
 end

 post '/signup' do
  @user = User.new(first_name: params[:first_name], username: params[:username], last_name: params[:last_name], email: params[:email], birthday: params[:birthday], password: params[:password])
  @user.save
  session['user_id'] = @user.id
  # flash[:info] = "Account Created! Welcome to Skate Kurb!"
   redirect "/allskaters"
 # "/users/skaters/#{@user.id}"
end

get "/users/:id" do
  @user = User.find(params["id"])
  erb :"/users/skaters"
end

get "/users/?" do
  @user = User.all
  erb :"/users/skaters"
end

post "/users/skaters/:id" do
  @user =  User.find(params["id"])
  @user.destroy
  session["user_id"] = nil
  redirect "/"
end



post "/articles/journalentries" do
  @user = User.find_by(id: session[:user_id])
  @journal = Journal.new(title: params[:title], subcategory: params[:subcategory], text: params[:text], created_at: params[:time], user_id: session[:user_id])
  @journal.save
  redirect "/users/skaters/#{@user.id}"
end

get "/articles/yourjournal" do
  @user = User.id(session[:user_id])
  redirect :skaters
end

get "/articles/:id" do
  @user =  User.find(params["id"])
  
  erb :"articles/yourjournal"
end

get "/articles/?" do
  @journal = Journal.last(20)
  erb :"/articles/yourjournal"
end

post "/articles/:id" do
   @journal =  Journal.find(params["id"])
  
  @journal.destroy

  redirect "/users/skaters"
end

get "/allskaters" do
  @all_journals = Journal.last(20)
  session['user_id'] == nil
  erb :allskaters
end





  


  







