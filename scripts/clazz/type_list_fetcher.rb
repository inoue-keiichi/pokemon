# frozen_string_literal: true

class TypeListFetcher
  TARGET_DIR = 'pokemon_data'
  TYPES = ['normal', 'fighting', 'flying', 'poison', 'ground', 'rock', 'bug', 'ghost', 'steel', 'fire', 'water', 'grass', 'electric', 'psychic', 'ice', 'dragon', 'dark', 'fairy'].freeze
  # order を付与するもっといい方法があるかも
  TYPE_ORDERS = [
    { name: 'normal', order: 0 },
    { name: 'fire', order: 1 },
    { name: 'water', order: 2 },
    { name: 'electric', order: 3 },
    { name: 'grass', order: 4 },
    { name: 'ice', order: 5 },
    { name: 'fighting', order: 6 },
    { name: 'poison', order: 7 },
    { name: 'ground', order: 8 },
    { name: 'flying', order: 9 },
    { name: 'psychic', order: 10 },
    { name: 'bug', order: 11 },
    { name: 'rock', order: 12 },
    { name: 'ghost', order: 13 },
    { name: 'dragon', order: 14 },
    { name: 'dark', order: 15 },
    { name: 'steel', order: 16 },
    { name: 'fairy', order: 17 }
  ].freeze

  def self.execute
    FileUtils.mkdir_p(TARGET_DIR)

    puts 'fetching type list ...'
    File.open("#{TARGET_DIR}/type_list.json", 'w') do |file|
      type_hash = TYPES.index_with do |type|
        damage_relations = PokeApi.get(type: type).damage_relations
        {
          name: I18n.t("type.#{type}"),
          damage: {
            double_from: damage_relations.double_damage_from.map(&:name),
            double_to: damage_relations.double_damage_to.map(&:name),
            half_from: damage_relations.half_damage_from.map(&:name),
            half_to: damage_relations.half_damage_to.map(&:name),
            no_from: damage_relations.no_damage_from.map(&:name),
            no_to: damage_relations.no_damage_to.map(&:name),
          },
          order: TYPE_ORDERS.find { |type_order| type_order[:name] == type }[:order]
        }
      end
    JSON.dump(type_hash.stringify_keys, file)
    end
    puts 'finish!!'
  end
end
