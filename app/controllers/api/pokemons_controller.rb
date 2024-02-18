# frozen_string_literal: true

class Api::PokemonsController < ApplicationController
  def index
    pokemon_list = PokemonList.new(region: params[:region])
    render json: Pokemon::Index::Serializer.new.serialize(pokemon_list).to_json
  end

  def show
    pokemon_profile = PokemonProfile.new id: params[:id].to_i
    render json: Pokemon::Show::Serializer.new.serialize(pokemon_profile).to_json
  end
end
