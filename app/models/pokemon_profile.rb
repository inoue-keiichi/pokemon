class PokemonProfile
  include ActiveModel::Model
  attr_reader :id

  def initialize(id:)
    @id = id
    @pokemon = PokeApi.get(pokemon: id)
    @pokemon_species = PokeApi.get(pokemon_species: @pokemon.name)
  end

  def name
    I18n.t("pokemon.#{@pokemon.name}")
  end

  def types
    @pokemon.types.map do |type|
      { slot: type.slot, name: I18n.t("type.#{type.type.name}"), url: type.type.url }
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
    @pokemon_species.flavor_text_entries.find do |entry|
      entry.language.name == 'ja' && entry.version.name == 'lets-go-pikachu'
    end&.flavor_text
  end

  def moves
    moves = @pokemon.moves.flat_map do |move|
      move.version_group_details.filter_map do |version_group_detail|
        if version_group_detail.version_group.name == 'lets-go-pikachu-lets-go-eevee'
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

  def version
    'lets-go-pikachu'
  end
end
