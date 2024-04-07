# frozen_string_literal: true

require 'rails_helper'
require './scripts/clazz/version_group_list_fetcher'

RSpec.describe 'VersionGroupListFetcher', :vcr do
  describe 'fetch' do

    before do
      FileUtils.rm_f('../../pokemon_data/version_group_list.json')
    end

    it 'fetch pokemon list' do
      VersionGroupListFetcher.execute(['lets-go-pikachu-lets-go-eevee', 'sword-shield', 'scarlet-violet'])
      result = JSON.load_file('pokemon_data/version_group_list.json')
      expect(result).to match(
        [
          {'name' => 'lets-go-pikachu-lets-go-eevee', 'regions' => ['kanto'], 'pokedexes' => ['letsgo-kanto'], 'versions' => ['lets-go-pikachu', 'lets-go-eevee']},
          {'name' => 'sword-shield', 'regions' => ['galar'], 'pokedexes' => ['galar', 'isle-of-armor', 'crown-tundra'], 'versions' => ['sword', 'shield']},
          {'name' => 'scarlet-violet', 'regions' => ['paldea'], 'pokedexes' => ['paldea', 'kitakami', 'blueberry'], 'versions' => ['scarlet', 'violet']}
        ]
      )
    end
  end
end
