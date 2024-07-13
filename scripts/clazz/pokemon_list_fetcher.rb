# frozen_string_literal: true

require 'graphql/client'
require 'graphql/client/http'
require 'panko_serializer'

module POKEAPI
  HTTP = GraphQL::Client::HTTP.new('https://beta.pokeapi.co/graphql/v1beta')
  Schema = GraphQL::Client.load_schema(HTTP)
  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
end

class InnerSerializer < Panko::Serializer
  attributes :id, :pokedex_number, :name, :display_name

  def id
    object.pokemon_v2_pokemonspecy.id
  end

  def name
    object.pokemon_v2_pokemonspecy.name
  end

  def display_name
    object.pokemon_v2_pokemonspecy.pokemon_v2_pokemonspeciesnames.first.name
  end
end

class PokemonListFetcher
  TARGET_DIR = 'pokemon_data/pokemon_list'

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

  def self.execute(pokedexes)
    return if pokedexes.blank?

    FileUtils.mkdir_p(TARGET_DIR)

    puts 'fetching pokemon list ...'
    res = POKEAPI::Client.query(Query, variables: {pokedexes: pokedexes}).data.pokemon_v2_pokedex
    res.each do |pokedex|
      json = Panko::ArraySerializer.new(pokedex.pokemon_v2_pokemondexnumbers, each_serializer: InnerSerializer).to_json
      File.open("#{TARGET_DIR}/#{pokedex.name}.json", 'w') do |file|

        JSON.dump(JSON.parse(json), file)
      end
    end
    puts 'finish!!'
  end
end
