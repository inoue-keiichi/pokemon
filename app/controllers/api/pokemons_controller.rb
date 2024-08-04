# frozen_string_literal: true

class Api::PokemonsController < ApplicationController
  def index
    pokedexes = params[:pokedexes]
    result = pokedexes.map do |pokedex|
      pokemons = JSON.load_file("pokemon_data/pokemon_list/#{pokedex}.json")
      {name: pokedex, pokemons: pokemons}
    end
    render json: result.to_json
  end

  def show
    input = Api::Pokemons::Shared::InputForm.new(id: params[:id].to_i, version_group: params[:version_group])
    return render(status: :bad_request, json: {errors: input.errors}) unless input.valid?

    pokemon = FetchPokemonByVersionGroup.new.execute(id: input.id, version_group: input.version_group)
    render json: pokemon
  end

  def forms
    input = Api::Pokemons::Shared::InputForm.new(id: params[:id].to_i, version_group: params[:version_group])
    output = ListPokemonFormsBySpeciesId.new.execute(pokemon_species_id: input.id, version_group: input.version_group)
    render json: output
  end

  def evolution_chain
    input = Api::Pokemons::Shared::InputForm.new(id: params[:id].to_i, version_group: params[:version_group])
    output = FetchEvolutionChain.new.execute(id: input.id, version_group: input.version_group)
    render json: Pokemon::EvolutionChain::Serializer.new.serialize(output).to_json
  end
end
