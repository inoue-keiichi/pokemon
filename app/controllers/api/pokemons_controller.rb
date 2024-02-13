# frozen_string_literal: true

class Api::PokemonsController < ApplicationController
  def index
    result = PokeApi.get(pokemon: { limit: 151, offset: 0 })
    render json: {
      results: result.results.map { |r| { name: I18n.t("pokemon.#{r.name}"), url: r.url, id: r.url.sub('https://pokeapi.co/api/v2/pokemon/', '').sub('/', '').to_i } }
    }
  end

  def show
    pokemon_profile = PokemonProfile.new id: params[:id].to_i
    render json: Pokemon::Show::Serializer.new.serialize(pokemon_profile).to_json
  end
end
