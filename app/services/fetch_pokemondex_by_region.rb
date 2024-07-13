# frozen_string_literal: true

# このクラス使ってる？
require 'graphql/client'
require 'graphql/client/http'

module POKEAPI
  # http アダプターを設定
  HTTP = GraphQL::Client::HTTP.new('https://beta.pokeapi.co/graphql/v1beta')

  # 上記を使って API サーバーから GraphQL Schema 情報を取得
  Schema = GraphQL::Client.load_schema(HTTP)

  # 上記を使ってクライアントを作成
  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
end

class FetchPokemondexByRegion
  Query = POKEAPI::Client.parse <<~GRAPHQL
    query($pokedexes: [String!]) {
      pokemon_v2_pokedex(where: {name: {_in: $pokedexes}}) {
        name
        pokemon_v2_pokemondexnumbers(order_by: {pokedex_number: asc}) {
          pokedex_number
          pokemon_v2_pokemonspecy {
            id
            name
            pokemon_v2_pokemonspeciesnames(where: {language_id: {_eq: 11}}) {
              name
            }
          }
        }
      }
    }
  GRAPHQL

  # query($region: String!) {
  #   pokemon_v2_region(where: {name: {_eq: $region}}) {
  #     name
  #     pokemon_v2_pokedexes {
  #       name
  #       pokemon_v2_pokemondexnumbers(order_by: {pokedex_number: asc}) {
  #         pokedex_number
  #         pokemon_v2_pokemonspecy {
  #           name
  #           pokemon_v2_pokemonspeciesnames(where: {language_id: {_eq: 11}}) {
  #             name
  #           }
  #         }
  #       }
  #     }
  #   }
  # }

  # query($version_group: String!) {
  #   pokemon_v2_versiongroup(where: {name: {_eq: $version_group}}) {
  #     id
  #     name
  #     pokemon_v2_pokedexversiongroups {
  #       pokemon_v2_pokedex {
  #         pokemon_v2_pokemondexnumbers(order_by: {pokedex_number: asc}) {
  #           pokedex_number
  #           pokemon_v2_pokemonspecy {
  #           id
  #           name
  #             pokemon_v2_pokemonspeciesnames(where: {language_id: {_eq: 11}}) {
  #               name
  #             }
  #           }
  #         }
  #       }
  #     }
  #   }
  # }

  def execute(pokedexes:)
    POKEAPI::Client.query(Query, variables: {pokedexes: pokedexes}).data.pokemon_v2_pokedex
  end
end
