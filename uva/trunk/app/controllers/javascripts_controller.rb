class JavascriptsController < ApplicationController
  def dynamic_accounts
      @accounts = Account.find(:all)
  end
end
