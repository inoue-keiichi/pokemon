# frozen_string_literal: true

require 'rails_helper'
require './scripts/clazz/pokemon_list_fetcher'

RSpec.describe 'PokemonListFetcher', :vcr do
  describe 'fetch' do

    before do
      FileUtils.rm_f('../../pokemon_data/pokemon_list/scarlet-violet.json')
    end

    it 'fetch pokemon list' do
      PokemonListFetcher.execute(['scarlet-violet'])
      result = JSON.load_file('pokemon_data/pokemon_list/scarlet-violet.json')
      expect(result['pokemons']).to include(
        {
          'id' => 4,
          'name' => 'ヒトカゲ',
          'pokedexes' => [{'entry_number' => 167, 'name' => 'blueberry'}],
          'region' => 'paldea',
        }, {
          'id' => 841,
          'name' => 'アップリュー',
          'pokedexes' =>
          [{'entry_number' => 109, 'name' => 'paldea'},
           {'entry_number' => 34, 'name' => 'kitakami'}],
          'region' => 'paldea'
        }
      )
    end
  end
end
