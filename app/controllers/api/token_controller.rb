# frozen_string_literal: true

class Api::TokenController < ApplicationController
  after_action :set_csrf_token_header, only: [:index]

  def index
    render json: {}
  end
end
