class FetchPokemonByVersionGroup
  include PokemonApi

  Query = PokemonApi::Client.parse <<~GRAPHQL
    query($id: Int!, $version_group_id: Int!) {
      pokemon_v2_pokemon(where: {id: {_eq: $id}}) {
        id
        pokemon_v2_pokemonspecy {
          id
          pokemon_v2_pokemonspeciesnames(where: {language_id: {_eq: 11}}) {
            name
          }
          pokemon_v2_pokemonspeciesflavortexts(where: {language_id: {_eq: 11}, pokemon_v2_version: {version_group_id: {_eq: $version_group_id}}}) {
            flavor_text
          }
        }
        pokemon_v2_pokemonforms {
          form_name
          pokemon_v2_pokemonformnames(where: {language_id: {_eq: 11}}) {
            name
          }
        }
        pokemon_v2_pokemontypes {
          slot
          pokemon_v2_type {
            pokemon_v2_typenames(where: {language_id: {_eq: 11}}) {
              name
            }
            pokemonV2TypeefficaciesByTargetTypeId {
              damage_factor
              pokemon_v2_type {
                name
              }
            }
          }
        }
        pokemon_v2_pokemonstats {
          pokemon_v2_stat {
            name
            pokemon_v2_statnames(where: {language_id: {_eq: 1}}) { # ja-Hrkt
              name
            }
          }
          base_stat
          effort
        }
        pokemon_v2_pokemonsprites {
          sprites
        }
        pokemon_v2_pokemonabilities {
          is_hidden
          pokemon_v2_ability {
            name
            pokemon_v2_abilityflavortexts(where: {language_id: {_eq: 11}}, order_by: {version_group_id: asc}) {
              flavor_text
              version_group_id
            }
            pokemon_v2_abilitynames(where: {language_id: {_eq: 11}}) {
              name
            }
          }
        }
        pokemon_v2_pokemonmoves(where: {pokemon_v2_versiongroup: {id: {_eq: $version_group_id}}}) {
          move_id
          level
            pokemon_v2_movelearnmethod {
            name
          }
          pokemon_v2_move {
            pokemon_v2_movenames(where: {language_id: {_eq: 11}}) {
              name
            }
            accuracy
            power
            pp
            priority
            type_id
            pokemon_v2_type {
              id
              name
              pokemon_v2_typenames(where: {language_id: {_eq: 11}}) {
                name
              }
            }
            pokemon_v2_moveflavortexts(where: {language_id: {_eq: 11}}, order_by: {version_group_id: asc}) {
              flavor_text
              version_group_id
            }
          }
        }
      }
    }
  GRAPHQL

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

  def execute(id:, version_group:)
    version_group_id = change_version_group_to_id(version_group)
    pokemon = PokemonApi::Client.query(Query, variables: {id: id, version_group_id: version_group_id}).data.pokemon_v2_pokemon[0]

    types = pokemon.pokemon_v2_pokemontypes.map do |p|
      Output::Type.new(
        slot: p.slot,
        name: p.pokemon_v2_type.pokemon_v2_typenames[0].name
      )
    end

    status = pokemon.pokemon_v2_pokemonstats.map do |s|
      Output::Status.new(
        name: s.pokemon_v2_stat.name.sub('-', '_'),
        label: s.pokemon_v2_stat.pokemon_v2_statnames[0].name,
        base_stat: s.base_stat,
        effort: s.effort
      )
    end

    sprites = build_sprites(pokemon)

    abilities = build_abilities(pokemon, version_group_id)

    moves = build_moves(pokemon, version_group_id)

    damage_from = build_damage_from(pokemon)

    form_type = build_form_type(pokemon.pokemon_v2_pokemonforms.first)

    Output.new(
      id: pokemon.id,
      species_id: pokemon.pokemon_v2_pokemonspecy.id,
      name: pokemon.pokemon_v2_pokemonspecy.pokemon_v2_pokemonspeciesnames[0].name,
      types: types,
      status: status,
      sprites: sprites, # sprites は複数返して欲しい場合ある？
      abilities: abilities,
      flavor_text: pokemon.pokemon_v2_pokemonspecy.pokemon_v2_pokemonspeciesflavortexts[0]&.flavor_text,
      moves: moves,
      damage_from: damage_from,
      form_type: form_type
    )
  end

  class Output
    attr_accessor :id, :species_id, :name, :types, :status, :sprites, :abilities, :flavor_text, :moves, :damage_from, :form_type

    def initialize(id:, species_id:, name:, types:, status:, sprites:, abilities:, flavor_text:, moves:, damage_from:, form_type:)
      @id = id
      @species_id = species_id
      @name = name
      @types = types
      @status = status
      @sprites = sprites
      @abilities = abilities
      @flavor_text = flavor_text
      @moves = moves
      @damage_from = damage_from
      @form_type = form_type
    end

    class Type
      attr_accessor :slot, :name

      def initialize(slot:, name:)
        @slot = slot
        @name = name
      end
    end

    class Status
      attr_accessor :name, :label, :base_stat, :effort

      def initialize(name:, label:, base_stat:, effort:)
        @name = name
        @label = label
        @base_stat = base_stat
        @effort = effort
      end
    end

    class Sprite
      attr_accessor :front_default

      def initialize(front_default:)
        @front_default = front_default
      end
    end

    class Ability
      attr_accessor :name, :is_hidden, :flavor_text

      def initialize(name:, is_hidden:, flavor_text:)
        @name = name
        @is_hidden = is_hidden
        @flavor_text = flavor_text
      end
    end

    class Move
      attr_accessor :id, :move_learn_method, :level, :name, :power, :accuracy, :pp, :type, :flavor_text

      def initialize(id:, move_learn_method:, level:, name:, power:, accuracy:, pp:, type:, flavor_text:)
        @id = id
        @move_learn_method = move_learn_method
        @level = level
        @name = name
        @power = power
        @accuracy = accuracy
        @pp = pp
        @type = type
        @flavor_text = flavor_text
      end
    end

    class FormType
      attr_accessor :type
      attr_accessor :name

      def initialize(type:, name:)
        @type = type
        @name = name
      end
    end
  end

  private

  def build_form_type(poke_form)
    return if poke_form.form_name.blank?

    name = case poke_form.form_name
           when 'mega', 'mega-x', 'mega-y'
             'メガシンカ'
           when 'gmax'
             'キョダイマックス'
           when 'paldea-combat-breed'
             'パルデアのすがた・コンバットしゅ'
           when  'paldea-blaze-breed'
             'パルデアのすがた・ブレイズしゅ'
           when 'paldea-aqua-breed'
             'パルデアのすがた・ウォーターしゅ'
           when 'terastal'
             'テラスタル'
           when 'stellar'
             'ステラ'
           else
             ''
           end
    return Output::FormType.new(type: poke_form.form_name, name: name)
  end

  def build_sprites(pokemon)
    front_default = pokemon.pokemon_v2_pokemonsprites.first.sprites['other']['official-artwork']['front_default'] ||
                    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/#{pokemon.id}.png" # TODO: 暫定対応

    return Output::Sprite.new(front_default: front_default)
  end

  def build_abilities(pokemon, version_group_id)
    pokemon.pokemon_v2_pokemonabilities.map do |a|
      ability = a.pokemon_v2_ability.pokemon_v2_abilityflavortexts.find{ |f| f.version_group_id == version_group_id } || a.pokemon_v2_ability.pokemon_v2_abilityflavortexts.last
      Output::Ability.new(
        name: a.pokemon_v2_ability.pokemon_v2_abilitynames[0].name,
        is_hidden: a.is_hidden,
        flavor_text: ability&.flavor_text
      )
    end
  end

  def build_moves(pokemon, version_group_id)
    pokemon.pokemon_v2_pokemonmoves.map do |m|
      move_flavor_text = m.pokemon_v2_move.pokemon_v2_moveflavortexts.find{ |f| f.version_group_id == version_group_id } || m.pokemon_v2_move.pokemon_v2_moveflavortexts.last
      Output::Move.new(
        id: m.move_id,
        move_learn_method: m.pokemon_v2_movelearnmethod.name,
        level: m.level,
        name: m.pokemon_v2_move.pokemon_v2_movenames[0].name,
        power: m.pokemon_v2_move.power,
        accuracy: m.pokemon_v2_move.accuracy,
        pp: m.pokemon_v2_move.pp,
        type: m.pokemon_v2_move.pokemon_v2_type.pokemon_v2_typenames[0].name,
        flavor_text: move_flavor_text&.flavor_text
      )
    end
  end

  def build_damage_from(pokemon)
    damage_from = TYPE_DAMAGE_INITIAL_HASH.dup
    pokemon.pokemon_v2_pokemontypes.each do |t|
      t.pokemon_v2_type.pokemon_v2_typeefficacies_by_target_type_id.each do |e|
        damage_from[e.pokemon_v2_type.name.to_sym] = damage_from[e.pokemon_v2_type.name.to_sym] * e.damage_factor / 100.0
      end
    end
    return damage_from
  end
end
