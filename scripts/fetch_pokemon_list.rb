# frozen_string_literal: true

class PokemonListFetcher
  TARGET_DIR = 'pokemon_data/pokemon_list'

  def self.execute(regions)
    return if regions.blank?

    FileUtils.mkdir_p(TARGET_DIR)

    regions.each do |region|
      File.open("#{TARGET_DIR}/#{region}.json", 'w') do |file|
        region = PokeApi.get(region: region)

        pokemons = get_pokemons(region.pokedexes)
        version_groups = region.version_groups.map(&:name)

        JSON.dump({pokemons: pokemons, version_groups: version_groups}, file)
      end
    end
  end

  class << self
    private

    def get_pokemons(pokedexes)
      pokemons = pokedexes.flat_map do |pokedex|
        pokedex_result = PokeApi.get(pokedex: pokedex.name)
        pokedex_result.pokemon_entries.map do |entry|
          pokemon = entry.pokemon_species
          {id: pokemon.url.sub('https://pokeapi.co/api/v2/pokemon-species/', '').sub('/', '').to_i, name:  I18n.t("pokemon.#{pokemon.name}"), }
        end
      end
      pokemons.uniq{ |pokemon| pokemon[:id] }.sort_by { |pokemon| pokemon[:id] }
    end
  end
end

PokemonListFetcher.execute(['kanto', 'johto', 'galar', 'paldea'])
