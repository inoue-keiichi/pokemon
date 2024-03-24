# frozen_string_literal: true

class FetchForms
  include PokemonUtil

  class Output
    attr_accessor :forms

    def initialize(forms:)
      @forms = forms
    end
  end

  def execute(id:, version_group:)
    @pokemon = PokeApi.get(pokemon: id)
    @pokemon_species = @pokemon.species.get

    forms = @pokemon_species.varieties.filter_map do |variety|
      unless variety.is_default
        version_groups = collect_version_groups(PokeApi.get(pokemon: variety.pokemon.name))
        {
          id: sub_id_from(variety.pokemon.url),
          name: I18n.t("pokemon.#{variety.pokemon.name}"),
          is_in_version_group: version_groups.include?(version_group)
        }
      end
    end
    Output.new(forms: forms)
  end


  private

  def collect_version_groups(pokemon)
    # どのバージョンに対応するかどうか判断する材料がmoveしかなかった...
    version_groups = pokemon.moves.flat_map do |move|
      move.version_group_details.map{ |version_group_detail| version_group_detail.version_group.name }
    end
    .uniq
    version_groups << 'sword-shield' if pokemon.name.include?('-gmax')
    version_groups
  end
end
