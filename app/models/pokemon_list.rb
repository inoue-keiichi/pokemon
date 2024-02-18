class PokemonList
  include ActiveModel::Model
  attr_reader :pokemons, :version_groups

  def initialize(region:)
    result = JSON.load_file("pokemon_data/pokemon_list/#{region}.json")
    @pokemons = result['pokemons']
    @version_groups = result['version_groups']
  end
end
