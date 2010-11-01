class ApidsController < ApplicationController
  def index
    @apids = Apid.all :order => :id
  end
end
