class IdentifyPokemon
  include Openai
  include PokemonApi

  class Output
    attr_accessor :id, :name

    def initialize(id:, name:)
      @id = id
      @name = name
    end
  end

  Query = PokemonApi::Client.parse <<~GRAPHQL
    query($name: String!) {
      pokemon_v2_pokemon(
        where: {pokemon_v2_pokemonspecy: {pokemon_v2_pokemonspeciesnames: {name: {_eq: $name}, language_id: {_eq: 11}}}}
      ) {
        id
        pokemon_v2_pokemonspecy {
          id
          pokemon_v2_pokemonspeciesnames(where: {language_id: {_eq: 11}}) {
            name
          }
        }
      }
    }
  GRAPHQL

  def execute(file:)
    base64 = Base64.encode64(file.tempfile.read)
    res = Openai::Client.chat(
      parameters: {
        model: 'gpt-4o-mini',
        messages: [{ role: 'user', content: [
          { type: 'text', text: 'この画像のポケモンの名前を schema の json 形式で回答してください。name にポケモンの名前を日本語で入れてください。'},
          { type: 'image_url',
            image_url: {
              url: "data:image/jpeg;base64,#{base64}",
              detail: 'low'
            }, }
        ]}],
        response_format: {
          type: 'json_schema',
          json_schema: {
            name: 'identify_pokemon',
            schema: {
              type: 'object',
              properties: {
                name: {
                  type: 'string',
                  description: 'ピカチュウ'
                }
              },
              additionalProperties: false,
              required: ['name']
            },
            strict: true
          }
        }
      }
    )
    pokemon_name = JSON.parse(res['choices'][0]['message']['content'])['name']
    pokemon = PokemonApi::Client.query(Query, variables: {name: pokemon_name}).data.pokemon_v2_pokemon[0]
    Output.new(id: pokemon.id, name: pokemon.pokemon_v2_pokemonspecy.pokemon_v2_pokemonspeciesnames[0].name)
  end

end
