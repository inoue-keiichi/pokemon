# frozen_string_literal: true

class TypeListFetcher
  TARGET_DIR = 'pokemon_data'
  # 並び順を公式と一緒にしているので変えないこと
  TYPES = ['normal', 'fire', 'water', 'electric', 'grass', 'ice', 'fighting', 'poison', 'ground', 'flying', 'psychic', 'bug', 'rock', 'ghost', 'dragon', 'dark', 'steel', 'fairy'].freeze

  def self.execute
    FileUtils.mkdir_p(TARGET_DIR)

    puts 'fetching type list ...'
    File.open("#{TARGET_DIR}/type_list.json", 'w') do |file|
      result = TYPES.map.with_index do |type, i|
        damage_relations = PokeApi.get(type: type).damage_relations
        {
          id: i + 1,
          label: I18n.t("type.#{type}"),
          value: type,
          damage: {
            double_from: damage_relations.double_damage_from.map(&:name),
            double_to: damage_relations.double_damage_to.map(&:name),
            half_from: damage_relations.half_damage_from.map(&:name),
            half_to: damage_relations.half_damage_to.map(&:name),
            no_from: damage_relations.no_damage_from.map(&:name),
            no_to: damage_relations.no_damage_to.map(&:name),
          },
        }.stringify_keys
      end
    JSON.dump(result, file)
    end
    puts 'finish!!'
  end
end
