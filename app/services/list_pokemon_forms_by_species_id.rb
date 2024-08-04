class ListPokemonFormsBySpeciesId
  include PokemonApi

  Query = PokemonApi::Client.parse <<~GRAPHQL
    query($pokemon_species_id: Int!, $version_group_id: Int!) {
      pokemon_v2_pokemon(where: {pokemon_species_id: {_eq: $pokemon_species_id}}) {
        id
        name
        is_default
        pokemon_v2_pokemonforms {
          name
          is_battle_only
          form_name
          version_group_id
          pokemon_v2_pokemonformnames(where: {language_id: {_eq: 11}}) {
            name
          }
        }
        pokemon_v2_pokemonspecy {
          pokemon_v2_pokemonspeciesnames(where: {language_id: {_eq: 11}}) {
            name
          }
        }
        pokemon_v2_pokemonmoves_aggregate(where: {version_group_id: {_eq: $version_group_id}}) {
          aggregate {
            count
          }
        }
      }
    }
  GRAPHQL

  def execute(pokemon_species_id:, version_group:)
    version_group_id = change_version_group_to_id(version_group)
    res = PokemonApi::Client.query(Query, variables: {pokemon_species_id: pokemon_species_id, version_group_id: version_group_id})

    forms = res.data.pokemon_v2_pokemon.flat_map do |poke|
      poke.pokemon_v2_pokemonforms.filter_map do |poke_form|
        # QL 側で処理したいが _or が機能してなかった？
        if poke_form.version_group_id == version_group_id || poke.pokemon_v2_pokemonmoves_aggregate.aggregate.count > 0
          name = build_name(poke_form, poke.pokemon_v2_pokemonspecy.pokemon_v2_pokemonspeciesnames[0].name)
          Output::Form.new(id: poke.id, name: name, is_default: poke.is_default, is_battle_only: poke_form.is_battle_only)
        end
      end
    end

    Output.new(forms: forms)
  end

  class Output
    attr_accessor :forms

    def initialize(forms:)
      @forms = forms
    end

    class Form
      attr_accessor :id, :name, :is_default, :is_battle_only

      def initialize(id:, name:, is_default:, is_battle_only:)
        @id = id
        @name = name
        @is_default = is_default
        @is_battle_only = is_battle_only
      end
    end


  end

  private

  def build_name(poke_form, origin_name)
    return "キョダイマックス#{origin_name}" if poke_form.form_name == 'gmax'

    case poke_form.form_name
    when 'paldea-combat-breed'
      return 'パルデアのすがた・コンバットしゅ'
    when  'paldea-blaze-breed'
      return 'パルデアのすがた・ブレイズしゅ'
    when 'paldea-aqua-breed'
      return 'パルデアのすがた・ウォーターしゅ'
    end

    return poke_form.pokemon_v2_pokemonformnames[0].name if poke_form.pokemon_v2_pokemonformnames[0]&.name.present?

    return origin_name
  end
end
