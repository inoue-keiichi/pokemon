# frozen_string_literal: true

class TypeListFetcher
  TARGET_DIR = 'pokemon_data'
  # 並び順を公式と一緒にしているので変えないこと
  TYPES = ['normal', 'fire', 'water', 'electric', 'grass', 'ice', 'fighting', 'poison', 'ground', 'flying', 'psychic', 'bug', 'rock', 'ghost', 'dragon', 'dark', 'steel', 'fairy'].freeze
  # order を付与するもっといい方法があるかも
  # TYPE_ORDERS = [
  #   {id:1, name: 'normal', order: 0 },
  #   {id:2, name: 'fire', order: 1 },
  #   {id:3, name: 'water', order: 2 },
  #   {id:4, name: 'electric', order: 3 },
  #   {id:5, name: 'grass', order: 4 },
  #   {id:6, name: 'ice', order: 5 },
  #   {id:7, name: 'fighting', order: 6 },
  #   {id:8, name: 'poison', order: 7 },
  #   {id:9,name: 'ground', order: 8 },
  #   {id:10, name: 'flying', order: 9 },
  #   {id:11, name: 'psychic', order: 10 },
  #   {id:12, name: 'bug', order: 11 },
  #   {id:13, name: 'rock', order: 12 },
  #   {id:14, name: 'ghost', order: 13 },
  #   {id:15, name: 'dragon', order: 14 },
  #   {id:16, name: 'dark', order: 15 },
  #   {id:17, name: 'steel', order: 16 },
  #   {id:18, name: 'fairy', order: 17 }
  # ].freeze

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
