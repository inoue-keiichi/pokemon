class PokemonProfile
  include ActiveModel::Model
  include PokemonUtil
  attr_reader :id

  TYPE_DAMAGE_INITIAL_HASH = {
    normal: 1,
    fighting: 1,
    flying: 1,
    poison: 1,
    ground: 1,
    rock: 1,
    bug: 1,
    ghost: 1,
    steel: 1,
    fire: 1,
    water: 1,
    grass: 1,
    electric: 1,
    psychic: 1,
    ice: 1,
    dragon: 1,
    dark: 1,
    fairy: 1,
    # 特殊なタイプなので一旦除去する
    # unknown: 1,　
    # shadow: 1,
  }.freeze

  def initialize(id:, version_group:)
    @id = id
    @version_group = FindMainVersionGroup.new.execute(name: version_group)
    @pokemon = PokeApi.get(pokemon: id)
    @pokemon_species = PokeApi.get(pokemon_species: @pokemon.name)
  end

  def name
    I18n.t("pokemon.#{@pokemon.name}")
  end

  def types
    @pokemon.types.map do |type|
      { slot: type.slot, name: type.type.name}
    end
  end

  def status
    @pokemon.stats.to_h do |stat|
      [stat.stat.name.sub('-', '_'), { base_stat: stat.base_stat, effort: stat.effort }]
    end
  end

  def sprites
    @pokemon.sprites
  end

  def flavor_text
    versions = @version_group.versions

    flaver_texts = @pokemon_species.flavor_text_entries.filter_map do |entry|
      {version: I18n.t("version.#{entry.version.name}"), value: entry.flavor_text} if entry.language.name == 'ja' && versions.include?(entry.version.name)
    end
    flaver_texts.present? ? flaver_texts.first[:value] : nil # 同世代のfravor_text は同じみたいなので1つだけ返す
  end

  def moves
    moves = @pokemon.moves.flat_map do |move|
      move.version_group_details.filter_map do |version_group_detail|
        if version_group_detail.version_group.name == @version_group.name
          {
            name: I18n.t("move.#{move.move.name}"),
            level_learned_at: version_group_detail.level_learned_at,
            move_learn_method: version_group_detail.move_learn_method.name
          }
        end
      end
    end
    moves.sort_by { |move| move[:level_learned_at] }
  end

  def damage_from
    damage_relations_list = @pokemon.types.map{ |type| PokeApi.get(type: type.type.name).damage_relations }
    result = TYPE_DAMAGE_INITIAL_HASH.dup
    damage_relations_list.each do |dr|
      dr.double_damage_from.each do |ddf|
        key = ddf.name.to_sym
        result[key] = result[key] * 2
      end
      dr.half_damage_from.each do |ddf|
        key = ddf.name.to_sym
        result[key] = result[key] * 0.5
      end
      dr.no_damage_from.each do |ddf|
        key = ddf.name.to_sym
        result[key] = result[key] * 0
      end
    end
    result
  end

  def version_group
    @version_group.name
  end

  def evolution_chain
    create_evolution_chain(@pokemon_species.evolution_chain.get.chain)
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
    if chain.evolves_to.blank?
      return  EvolutionChain.new(id: id, name: name, is_baby: chain.is_baby, evolution_details: chain.evolution_details, evolves_to: [],
                                 is_in_version_group: is_in_version_group)
    end

    evolves_to = chain.evolves_to.map{ |ev_to| create_evolution_chain(ev_to) }
    EvolutionChain.new(id: id, name: name, is_baby: chain.is_baby, evolution_details: chain.evolution_details, evolves_to: evolves_to, is_in_version_group: is_in_version_group)
  end
end
