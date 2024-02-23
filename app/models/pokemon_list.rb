class PokemonList
  include ActiveModel::Model
  attr_reader :pokemons, :pokedexes, :version_groups

  def initialize(region:)
    result = JSON.load_file("pokemon_data/pokemon_list/#{region}.json")
    @pokemons = result['pokemons']
    @pokedexes = result['pokedexes']
    @version_groups = result['version_groups']
  end
end
