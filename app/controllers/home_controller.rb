class HomeController < ApplicationController
  load_and_authorize_resource class: false


  def index 
    render plain: "You probably shouldn't be here."
  end

  private 

  def starling_api 
    @starling_api ||= StarlingApi.new 
  end

  def smoobu_api
    @smoobu_api ||= SmoobuApi.new 
  end




end