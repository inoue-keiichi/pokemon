require 'graphql/client'
require 'graphql/client/http'

module PokemonApi
  extend ActiveSupport::Concern

  # http アダプターを設定
  HTTP = GraphQL::Client::HTTP.new('https://beta.pokeapi.co/graphql/v1beta')

  # 上記を使って API サーバーから GraphQL Schema 情報を取得
  Schema = GraphQL::Client.load_schema(HTTP)

  # 上記を使ってクライアントを作成
  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
end
