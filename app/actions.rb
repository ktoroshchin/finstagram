helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end
end

get '/' do
  @posts=Post.order(created_at: :desc)
  erb(:index)
end

get '/signup' do
  @user=User.new
  erb(:signup)
end

post '/signup' do
  email      = params[:email]
  avatar_url = params[:avatar_url]
  username   = params[:username]
  password   = params[:password]
  
  @user = User.new({ email: email, avatar_url: avatar_url, username: username, password: password})

  if @user.save
    redirect to('/login')
  else
    erb(:signup)
  end
end

get '/login' do  # when a GET request comes into /login
  erb(:login)  # render app/views/login.erb
end

post '/login' do                
                              
  username = params[:username]# when we submit a form with an action of /login
  password = params[:password] 
  
      # 1. find user by username
      user=User.find_by(username: username)
      # 2. if that user exists
       if user && user.password == password
         session[:user_id]=user.id
         redirect to('/')
      else
        @error_message = "Login failed."
        erb(:login)
       end
  end
  
  
  get '/logout' do
    session[:user_id] = nil
    redirect to('/')
  end
  
get '/posts/new' do
  @post = Post.new
  erb(:"posts/new")
end
  
post '/posts' do
  photo_url = params[:photo_url]
  
  #instantiate new Post
  @post= Post.new({ photo_url: photo_url, user_id: current_user.id})
  
  #if @post validates, save
  if @post.save
    redirect(to('/'))
  else
  #if it does not validate, print error message
    erb(:"posts/new")
  end
end
  
  
  
get '/posts/:id' do
  @post = Post.find(params[:id])  # find the post with the ID from the URL
  erb(:"posts/show")       # print to the screen for now
end


post '/comments' do 
  text = params[:text]
  post_id = params[:post_id]
  # instantiate a comment with those values & assign the comment to the `current_user`
  comment = Comment.new({ text: text, post_id: post_id, user_id: current_user.id })
  
  comment.save
  # `redirect` back to wherever we came from
  redirect(back)
end


post '/likes' do
  post_id = params[:post_id]
  
  like = Like.new({ post_id: post_id, user_id: current_user.id})
  like.save
  
  redirect(back)
end







  # u=user.find(1)
  #u.email="email"
  #u.password="password"
  #or 
  #u=user.find(1)or(2)or(3)
  #u.update(email:"", password:"")

  

