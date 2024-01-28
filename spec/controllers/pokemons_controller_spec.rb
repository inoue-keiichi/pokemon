require 'rails_helper'

RSpec.describe 'Pokemons', type: :request do
  before do
    poke_api = spy(PokeApi)
    allow(PokeApi).to receive(:get).and_return(
      Pokedex.new(
        [
          {
            entry_number: 1,
            pokemon_species:{
              name:"hoge",
              url:"https://pokeapi.co/api/v2/pokemon-species/1"
            }
          }
        ]
      )
    )
  end

  describe 'GET #index' do
    it 'データを取得する' do
      get '/pokemons'
      expect(response).to have_http_status(:success)
    end
  end
end

class Pokedex
  attr_accessor :pokemon_entries

  def initialize(pokemon_entries)
    @pokemon_entries = pokemon_entries
  end
end
