# frozen_string_literal: true

class PokemonListFetcher
  TARGET_DIR = 'pokemon_data/pokemon_list'

  def self.execute(regions)
    return if regions.blank?

    FileUtils.mkdir_p(TARGET_DIR)

    puts 'fetching pokemon list ...'
    regions.each do |region_name|
      File.open("#{TARGET_DIR}/#{region_name}.json", 'w') do |file|
        region = PokeApi.get(region: region_name)

        pokemons = region.pokedexes.flat_map{ |pokedex| get_pokemons(pokedex.name) }
        pokemons = merge_pokedex(pokemons).sort_by { |pokemon| pokemon[:id] }

        pokedexes = region.pokedexes.map(&:name)
        version_groups = region.version_groups.map(&:name)

        JSON.dump({pokemons: pokemons, pokedexes: pokedexes, version_groups: version_groups}, file)
        puts "#{region_name} is done."
      end
    end
    puts 'finish!!'
  end

  class << self
    private

    def get_pokemons(pokedex)
      pokedex_result = PokeApi.get(pokedex: pokedex)
      pokedex_result.pokemon_entries.map do |entry|
        pokemon = entry.pokemon_species
        {
          id: pokemon.url.sub('https://pokeapi.co/api/v2/pokemon-species/', '').sub('/', '').to_i,
          name: I18n.t("pokemon.#{pokemon.name}"),
          region: pokedex_result.region.name,
          pokedexes: [name: pokedex_result.name, entry_number: entry.entry_number],
        }
      end
    end

    def merge_pokedex(pokemons)
      pokemons.group_by{ |p| p[:id] }.values.map do |value|
        value.inject do |result, v|
          result.merge(v) do |key, oldval, newval|
            key == :pokedexes ? oldval.concat(newval) : newval
          end
        end
      end
    end
  end
end
