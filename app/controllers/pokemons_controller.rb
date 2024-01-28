class PokemonsController < ApplicationController
  def index
    @pokemon_entries = PokeApi.get(pokedex: "kanto").pokemon_entries
    render json: @pokemon_entries
  end
end
