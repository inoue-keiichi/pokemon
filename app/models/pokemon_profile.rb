class PokemonProfile
  include ActiveModel::Model
  attr_reader :id, :version_group

  def initialize(id:, version_group:)
    @id = id
    @version_group = version_group
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
    versions = PokeApi.get(version_group: @version_group).versions.map(&:name)

    flaver_texts = @pokemon_species.flavor_text_entries.filter_map do |entry|
      {version: I18n.t("version.#{entry.version.name}"), value: entry.flavor_text} if entry.language.name == 'ja' && versions.include?(entry.version.name)
    end
    flaver_texts.present? ? flaver_texts.first[:value] : nil # 同世代のfravor_text は同じみたいなので1つだけ返す

    nil
  end

  def moves
    moves = @pokemon.moves.flat_map do |move|
      move.version_group_details.filter_map do |version_group_detail|
        if version_group_detail.version_group.name == @version_group
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
end
