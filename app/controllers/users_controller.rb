class UsersController < ApplicationController
  def index
    @users = User.all.order({ :username => :asc })

    render({ :template => "users/index.html" })
  end

  def show
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)

    render({ :template => "users/show.html.erb" })
  end
  def new_session
    #get user and pass from params
    un = params.fetch("input_username")
    pw = params.fetch("input_password")
    #lookup record from db matching user
    user = User.where({:username => un}).at(0)
    #if no record redirect to sign in
    if user == nil
      redirect_to("/user_sign_in", {:alert => "ERROR: UNAUTHORIZED USER ATTEMPTING TO GAIN ACCESS"})
    else
      if user.authenticate(pw)
          session.store(:user_id, user.id)
          redirect_to("/users/#{user.username}", {:notice => "Welcome back, " + user.username + "!"})
      else    #if record but bad pass redirect to sign in
        redirect_to("/user_sign_in", {:alert => "That's the wrong password, mate"})
      end
    end
  end

  def sign_in
    render({ :template => "users/sign_in.html.erb" })
  end
  def new_reg
    render({ :template => "users/reg.html.erb" })
  end
  def kill_cookie
    reset_session
    redirect_to("/", :notice => "See ya later!")
  end
  def create
    user = User.new

    user.username = params.fetch("input_username")
    user.password = params.fetch("input_password")
    user.password_confirmation = params.fetch("input_password_conf")

    save_status = user.save
    if save_status == true
      session.store(:user_id, user.id)

      redirect_to("/users/#{user.username}", {:notice => "Welcome, " + user.username + "!"})
    else
      redirect_to("/user_sign_up", {:alert => user.errors.full_messages.to_sentence})
    end
  end

  def update
    the_id = params.fetch("the_user_id")
    user = User.where({ :id => the_id }).at(0)


    user.username = params.fetch("input_username")

    user.save
    
    redirect_to("/users/#{user.username}")
  end

  def destroy
    username = params.fetch("the_username")
    user = User.where({ :username => username }).at(0)

    user.destroy

    redirect_to("/users")
  end

end
