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
  attributes :id, :pokedex_number, :name, :display_name, :sprite_path

  def id
    object.pokemon_v2_pokemonspecy.id
  end

  def name
    object.pokemon_v2_pokemonspecy.name
  end

  def display_name
    object.pokemon_v2_pokemonspecy.pokemon_v2_pokemonspeciesnames.first.name
  end

  def sprite_path
    context[:id_to_sprite_hash][object.pokemon_v2_pokemonspecy.id]
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

  Query2 = POKEAPI::Client.parse <<~GRAPHQL
    query ($pokemon_ids: [Int!]) {
      pokemon_v2_pokemonsprites(where: {pokemon_id: {_in: $pokemon_ids}}) {
        pokemon_id
        sprites(path: "front_default")
      }
    }
  GRAPHQL


  def self.execute(pokedexes)
    return if pokedexes.blank?

    FileUtils.mkdir_p(TARGET_DIR)

    puts 'fetching pokemon list ...'
    pokedexes = POKEAPI::Client.query(Query, variables: {pokedexes: pokedexes}).data.pokemon_v2_pokedex

    pokemon_species_ids = pokedexes.map { |pokedex| pokedex.pokemon_v2_pokemondexnumbers.map{ |pokemondexnumber| pokemondexnumber.pokemon_v2_pokemonspecy.id} }.flatten
    res = POKEAPI::Client.query(Query2, variables: {pokemon_ids: pokemon_species_ids})
    id_to_sprite_hash = res.data.pokemon_v2_pokemonsprites.map { |pokemonsprite| [pokemonsprite.pokemon_id, pokemonsprite.sprites] }.to_h

    pokedexes.each do |pokedex|
      json = Panko::ArraySerializer.new(pokedex.pokemon_v2_pokemondexnumbers, context: {id_to_sprite_hash: id_to_sprite_hash}, each_serializer: InnerSerializer).to_json
      File.open("#{TARGET_DIR}/#{pokedex.name}.json", 'w') do |file|

        JSON.dump(JSON.parse(json), file)
      end
    end
    puts 'finish!!'
  end
end
