# frozen_string_literal: true

class Api::PokemonsController < ApplicationController
  def index
    pokemon_list = PokemonList.new(region: params[:version_group])
    render json: Pokemon::Index::Serializer.new.serialize(pokemon_list).to_json
  end

  def show
    input = Api::Pokemons::Show::InputForm.new(id: params[:id].to_i, version_group: params[:version_group])
    return render(status: :bad_request, json: {errors: input.errors}) unless input.valid?

    pokemon_profile = PokemonProfile.new(id: input.id, version_group: input.version_group)
    render json: Pokemon::Show::Serializer.new.serialize(pokemon_profile).to_json
  end
end
