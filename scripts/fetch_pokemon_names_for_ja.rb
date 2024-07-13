require 'graphql/client'
require 'graphql/client/http'
require 'yaml'

module SWAPI
  # http アダプターを設定
  HTTP = GraphQL::Client::HTTP.new('https://beta.pokeapi.co/graphql/v1beta')

  # 上記を使って API サーバーから GraphQL Schema 情報を取得
  Schema = GraphQL::Client.load_schema(HTTP)

  # 上記を使ってクライアントを作成
  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
end

PokemonListQuery = SWAPI::Client.parse <<~GRAPHQL
  query PokemonName {
    pokemon_v2_pokemonspecies(order_by: {id: asc}) {
      name
      pokemon_v2_pokemonspeciesnames(where: {language_id: {_eq: 11}}) { # 11 は ja
        name
      }
    }
  }
GRAPHQL

pokemon_species = SWAPI::Client.query(PokemonListQuery::PokemonName).data.pokemon_v2_pokemonspecies
data = pokemon_species.to_h{ |ps| [ps.name, ps.pokemon_v2_pokemonspeciesnames.first.name] }

YAML.dump({'ja' => {'pokemon' => data}}, File.open('./tmp/pokemon_list.yml', 'w'))
