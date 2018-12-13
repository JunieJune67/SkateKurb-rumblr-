require "sinatra/activerecord"
require "sinatra"
require "sinatra/flash"

enable :sessions


set :database, {adapter: "sqlite3", database: "database.sqlite3"}

class User < ActiveRecord::Base
    
end

class Journals < ActiveRecord::Base

end

get '/' do
     if session['user_id'] != nil
    @journals = journal.where(user_id :session['user_id']).order(created_at: :desc)
     end
     p session
erb :home
end

#New Users are signing Up
post '/' do
    @user = User.new(first_name: params[:first_name], last_name: params[:last_name], email: params[:email], birthday: params[:birthday])
    @user.save
    session['user_id'] = @user_id
    flash[:flash] = "Account Created! Welcome to Skate Kurb!"
    redirect '/users/skaters/#{@user.id}'
    
    
   end

   get '/users/skaters' do
    "Hello World"
  end


#Current User are being Displayed & already Logged In
get '/users/new' do 
   if session['user_id'] != nil
    flash[:flash] = 'Skater was already on Board'
   redirect '/'
end
   erb :'/users/new'
end

get '/login' do
erb :'/login'
end



#Users searching 
post '/login' do 
@user = User.find(email: params[:email])
if @user != nil
    if @user.password == params[:password]
        session['user_id'] = @user.id
        redirect '/'
    else
        redirect '/login'
end
end
redirect '/login'
end

#Users writing their articles if Logged in
get '/articles/new' do
if session['user_id'] == nil
flash[:flash] ='User was not logged in'
  redirect '/'
end
  erb :'/articles/new'
end

get '/articles/entries' do
" "
   
end


#Users articles are up and ready for viewing
post '/articles/entries' do 
    flash[:flash] = "article published!"
    @article = Article.new(title: params['title'], subcategory: params['topic'], text: params['text'], user_id: session['user_id'])
    @article.save
    redirect '/articles/entries/#{@article.id}'
end

delete '/articles/:id' do 
    @article = Article.find(params['article_id'])
    @article.destroy
    flash[:flash] = "Jounal Officially Trashed!"
    redirect "/articles/new"
end
#Users Logged Out
get '/logout' do
session['user_id'] = nil
flash[:flash] = "Sucessfully Logged out C' Ya!"
redirect '/'
end



