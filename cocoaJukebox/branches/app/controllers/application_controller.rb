# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'e03cbd0bf8fb05d8840e0580e5997b96'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  protected
  def do_basic_auth
    # moku's Goldberg variation.
    # a massive hack.
    #
    # it partially initializes Goldberg's security system to find out who's logged in.
    # if it's a public user, or no user, tries to do HTTP Basic auth.
    # 
    # Prolly still needs a lot of cleanup.
    
    session[:goldberg] ||= Hash.new
    session[:goldberg][:path] = request.path
    Goldberg::AuthController.set_user(session)
    
    if Goldberg.user and Goldberg.user.role.name != "Public"
      logger.debug "User #{Goldberg.user.name} already logged in (Role: #{Goldberg.user.role.name}), not using HTTP Basic"
    else
      authenticate_or_request_with_http_basic do |username, password|
        if username and password
          user = Goldberg::User.find_by_name(username)
          if user and user.check_password(password)
            logger.info "User #{username} successfully logged in"
            Goldberg.user = user
            Goldberg::AuthController.set_user(session, user.id)
          else
            logger.warn "Failed login attempt"
          end
        end
      end
    end
  end  # def try_basic_auth
end
