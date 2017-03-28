class HomeController < ApplicationController
  def index
    redirect_to inscription_path
  end
end
