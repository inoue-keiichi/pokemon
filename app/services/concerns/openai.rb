require 'openai'

module Openai
  extend ActiveSupport::Concern

  Client = OpenAI::Client.new(access_token: ENV.fetch('OPENAI_ACCESS_TOKEN', nil))
end
