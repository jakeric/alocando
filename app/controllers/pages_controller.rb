class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    render plain: "HELLO"
  end

  def about
  end

  def terms
  end

  def faq
  end

end
