# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pokemon', type: :request do
  describe '#index' do
    it 'get pokemon list', :vcr do
      get api_pokemons_path, params: {region: 'kanto'}
      expect(response).to have_http_status(:success)
      body = response.parsed_body
      expect(body['pokemons'].size).to eq 153
      expect(body['pokemons']).to include(
        {
          'id' => 1,
          'name' => 'フシギダネ',
          'pokedexes' => [
            {'entry_number' => 1, 'name' => 'kanto'},
            {'entry_number' => 1, 'name' => 'letsgo-kanto'}
          ], 'region' => 'kanto'
        },
        {
          'id' => 808,
          'name' => 'メルタン',
          'pokedexes' => [{'entry_number' => 152, 'name' => 'letsgo-kanto'}],
          'region' => 'kanto'
        }
      )
    end
  end

  describe '#show' do
    let(:id) { 25 } # ピカチュウ

    it 'get pokemon data', :vcr do
      get api_pokemon_path(id), params: {region: 'kanto'}
      expect(response).to have_http_status(:success)
      expect(response.parsed_body).to match(
        {'id' => 25,
         'name' => 'ピカチュウ',
         'types' => [{'slot' => 1, 'name' => 'でんき', 'url' => 'https://pokeapi.co/api/v2/type/13/'}],
         'status' =>
       {'hp' => {'base_stat' => 35, 'effort' => 0},
        'attack' => {'base_stat' => 55, 'effort' => 0},
        'defense' => {'base_stat' => 40, 'effort' => 0},
        'special_attack' => {'base_stat' => 50, 'effort' => 0},
        'special_defense' => {'base_stat' => 50, 'effort' => 0},
        'speed' => {'base_stat' => 90, 'effort' => 2}},
         'sprites' =>
       {'back_female' => 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/female/25.png',
        'back_shiny_female' => 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/female/25.png',
        'back_default' => 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/25.png',
        'front_female' => 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/female/25.png',
        'front_shiny_female' => 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/female/25.png',
        'back_shiny' => 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/25.png',
        'front_default' => 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
        'front_shiny' => 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/25.png'},
         'flavor_text' => "森に　棲む　ポケモン。　ほっぺの\nふくろは　電気を　ためるので\n触ると　パチパチ　痺れるぞ。",
         'moves' =>
       [{'name' => 'めいそう', 'level_learned_at' => 0, 'move_learn_method' => 'machine'},
        {'name' => 'かみなりパンチ', 'level_learned_at' => 0, 'move_learn_method' => 'machine'},
        {'name' => 'あなをほる', 'level_learned_at' => 0, 'move_learn_method' => 'machine'},
        {'name' => 'どくどく', 'level_learned_at' => 0, 'move_learn_method' => 'machine'},
        {'name' => 'ひかりのかべ', 'level_learned_at' => 0, 'move_learn_method' => 'machine'},
        {'name' => 'リフレクター', 'level_learned_at' => 0, 'move_learn_method' => 'machine'},
        {'name' => 'ねむる', 'level_learned_at' => 0, 'move_learn_method' => 'machine'},
        {'name' => 'みがわり', 'level_learned_at' => 0, 'move_learn_method' => 'machine'},
        {'name' => 'まもる', 'level_learned_at' => 0, 'move_learn_method' => 'machine'},
        {'name' => 'アイアンテール', 'level_learned_at' => 0, 'move_learn_method' => 'machine'},
        {'name' => 'からげんき', 'level_learned_at' => 0, 'move_learn_method' => 'machine'},
        {'name' => 'てだすけ', 'level_learned_at' => 0, 'move_learn_method' => 'machine'},
        {'name' => 'れんぞくぎり', 'level_learned_at' => 0, 'move_learn_method' => 'machine'},
        {'name' => 'ネコにこばん', 'level_learned_at' => 0, 'move_learn_method' => 'machine'},
        {'name' => 'ずつき', 'level_learned_at' => 0, 'move_learn_method' => 'machine'},
        {'name' => 'ちきゅうなげ', 'level_learned_at' => 0, 'move_learn_method' => 'machine'},
        {'name' => '１０まんボルト', 'level_learned_at' => 0, 'move_learn_method' => 'machine'},
        {'name' => 'でんじは', 'level_learned_at' => 0, 'move_learn_method' => 'machine'},
        {'name' => 'かみなり', 'level_learned_at' => 0, 'move_learn_method' => 'machine'},
        {'name' => 'なきごえ', 'level_learned_at' => 1, 'move_learn_method' => 'level-up'},
        {'name' => 'でんきショック', 'level_learned_at' => 1, 'move_learn_method' => 'level-up'},
        {'name' => 'しっぽをふる', 'level_learned_at' => 3, 'move_learn_method' => 'level-up'},
        {'name' => 'でんこうせっか', 'level_learned_at' => 6, 'move_learn_method' => 'level-up'},
        {'name' => 'にどげり', 'level_learned_at' => 9, 'move_learn_method' => 'level-up'},
        {'name' => 'かげぶんしん', 'level_learned_at' => 12, 'move_learn_method' => 'level-up'},
        {'name' => 'でんじは', 'level_learned_at' => 15, 'move_learn_method' => 'level-up'},
        {'name' => 'ひかりのかべ', 'level_learned_at' => 18, 'move_learn_method' => 'level-up'},
        {'name' => '１０まんボルト', 'level_learned_at' => 21, 'move_learn_method' => 'level-up'},
        {'name' => 'たたきつける', 'level_learned_at' => 24, 'move_learn_method' => 'level-up'},
        {'name' => 'こうそくいどう', 'level_learned_at' => 27, 'move_learn_method' => 'level-up'},
        {'name' => 'かみなり', 'level_learned_at' => 30, 'move_learn_method' => 'level-up'}],
         'version_group' => 'lets-go-pikachu-lets-go-eevee'}
      )
    end

    context 'get pokemon data which has moves with same names' do
      let(:id) { 3 } # フシギバナ

      it '', :vcr do
        get api_pokemon_path(id), params: {region: 'kanto'}
        expect(response).to have_http_status(:success)
        expect(response.parsed_body['moves']).to include(
          {'name' => 'はなびらのまい', 'level_learned_at' => 0, 'move_learn_method' => 'level-up'},
          {'name' => 'はなびらのまい', 'level_learned_at' => 1, 'move_learn_method' => 'level-up'}
        )
      end
    end
  end
end
