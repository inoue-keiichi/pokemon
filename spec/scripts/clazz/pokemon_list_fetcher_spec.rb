# frozen_string_literal: true

require 'rails_helper'
require './scripts/clazz/pokemon_list_fetcher'

RSpec.describe 'PokemonListFetcher', :vcr do
  describe 'fetch' do

    before do
      FileUtils.rm_f('../../pokemon_data/pokemon_list/paldea.json')
      FileUtils.rm_f('../../pokemon_data/pokemon_list/kitakami.json')
      FileUtils.rm_f('../../pokemon_data/pokemon_list/blueberry.json')
    end

    it 'fetch pokemon list' do
      PokemonListFetcher.execute(['paldea', 'kitakami', 'blueberry'])
      blueberry = JSON.load_file('pokemon_data/pokemon_list/blueberry.json')
      expect(blueberry).to include(
        {
          'id' => 4,
          'name' => 'charmander',
          'display_name' => 'ヒトカゲ',
          'pokedex_number' => 167
        }
      )

      paldea = JSON.load_file('pokemon_data/pokemon_list/paldea.json')
      expect(paldea).to include(
        {
          'id' => 841,
          'name' => 'flapple',
          'display_name' => 'アップリュー',
          'pokedex_number' => 109
        }
      )
      kitakami = JSON.load_file('pokemon_data/pokemon_list/kitakami.json')
      expect(kitakami).to include(
        {
          'id' => 841,
          'name' => 'flapple',
          'display_name' => 'アップリュー',
          'pokedex_number' => 34
        }
      )
    end
  end
end
