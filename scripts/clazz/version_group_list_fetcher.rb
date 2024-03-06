# frozen_string_literal: true

class VersionGroupListFetcher
  TARGET_DIR = 'pokemon_data'

  def self.execute(version_group_names)
    return if version_group_names.blank?

    FileUtils.mkdir_p(TARGET_DIR)

    puts 'fetching version group list ...'
    File.open("#{TARGET_DIR}/version_group_list.json", 'w') do |file|
      result = []
      version_group_names.each do |version_group_name|
        version_group = PokeApi.get(version_group: version_group_name)
        result << {name: version_group.name, regions: version_group.regions.map(&:name), pokedexes: version_group.pokedexes.map(&:name), versions: version_group.versions.map(&:name)}
      end

      JSON.dump(result, file)
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
