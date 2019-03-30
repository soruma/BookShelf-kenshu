# frozen_string_literal: true

# 著者コントローラー
class AuthorsController < ApplicationController
  def index
    @authors = Person.includes(:books).all
  end
end
