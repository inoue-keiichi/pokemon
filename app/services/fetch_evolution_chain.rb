# frozen_string_literal: true

class FetchEvolutionChain
  include PokemonUtil

  class Output
    attr_accessor :evolution_chain

    def initialize(evolution_chain:)
      @evolution_chain = evolution_chain
    end
  end

  def execute(id:, version_group:)
    @version_group = FindMainVersionGroup.new.execute(name: version_group)
    @pokemon_species = PokeApi.get(pokemon: id).species.get

    evolution_chain = create_evolution_chain(@pokemon_species.evolution_chain.get.chain)
    Output.new(evolution_chain: evolution_chain)
  end


  private

  class EvolutionChain
    def initialize(id:, name:, is_baby:, evolution_details:, evolves_to:, is_in_version_group:)
      @id = id
      @name = name
      @is_baby = is_baby
      @evolution_details = evolution_details
      @evolves_to = evolves_to
      @is_in_version_group = is_in_version_group
    end
  end

  def create_evolution_chain(chain)
    id = sub_id_from(chain.species.url)
    name = I18n.t("pokemon.#{chain.species.name}")
    chain_pokemon_species = PokeApi.get(pokemon_species: chain.species.name)
    pokedex_names_of_pokemon_species = chain_pokemon_species.pokedex_numbers.map{ |pokedex_number| pokedex_number.pokedex.name }
    is_in_version_group = @version_group.pokedexes.any? { |pokedex| pokedex_names_of_pokemon_species.include?(pokedex) }
    evolution_details = chain.evolution_details.map{ |evolution_detail| build_evolution_detail(evolution_detail) }
    if chain.evolves_to.blank?
      return  EvolutionChain.new(id: id, name: name, is_baby: chain.is_baby, evolution_details: evolution_details, evolves_to: [],
                                 is_in_version_group: is_in_version_group)
    end

    evolves_to = chain.evolves_to.map{ |ev_to| create_evolution_chain(ev_to) }
    EvolutionChain.new(id: id, name: name, is_baby: chain.is_baby, evolution_details: evolution_details, evolves_to: evolves_to, is_in_version_group: is_in_version_group)
  end

  def build_evolution_detail(evolution_detail)
    result = ''
    result += 'なつかせて' if evolution_detail.min_happiness.present?
    result += "#{I18n.t("type.#{evolution_detail.known_move_type.name}")}タイプの技を覚えた状態で" if evolution_detail.known_move_type.present?
    result += '朝/昼に' if evolution_detail.time_of_day == 'day'
    result += '夜に' if evolution_detail.time_of_day == 'night'
    result += "Lv.#{evolution_detail.min_level}以上で" if evolution_detail.min_level.present?
    case evolution_detail.trigger.name
    when 'level-up'
      "#{result}レベルアップ"
    when 'use-item'
      item_name = evolution_detail.item.get.names.find{ |name| name.language.name == 'ja' || name.language.name == 'ja-Hrkt' }&.name
      "#{result}#{item_name}を使う"
    else
      # 未対応の進化方法がある場合
      '進化方法を表示できません'
    end
  end
end
