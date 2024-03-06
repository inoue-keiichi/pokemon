# frozen_string_literal: true

class PokemonListFetcher
  TARGET_DIR = 'pokemon_data/pokemon_list'

  def self.execute(version_group_names)
    return if version_group_names.blank?

    FileUtils.mkdir_p(TARGET_DIR)

    puts 'fetching pokemon list ...'
    version_group_names.each do |version_group_name|
      File.open("#{TARGET_DIR}/#{version_group_name}.json", 'w') do |file|
        version_group = fetch_version_group(version_group_name)

        pokemons = version_group.pokedexes.flat_map{ |pokedex| get_pokemons(pokedex.name) }
        pokemons = merge_pokedex(pokemons).sort_by { |pokemon| pokemon[:id] }

        pokedexes = version_group.pokedexes.map(&:name)

        JSON.dump({pokemons: pokemons, pokedexes: pokedexes}, file)
        puts "#{version_group_name} is done."
      end
    end
    puts 'finish!!'
  end

  class << self
    private

    Pokedex = Struct.new(:name)

    def fetch_version_group(version_group_name)
      version_group = PokeApi.get(version_group: version_group_name)
      # SVは version_group のレスポンスに追加コンテンツが含まれていないので hash で持っておく
      return version_group if version_group_name != 'scarlet-violet'

      version_group.pokedexes.push(Pokedex.new('kitakami'), Pokedex.new('blueberry'))
      version_group
    end

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
