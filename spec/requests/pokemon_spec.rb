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

  describe '#show', :vcr do
    let(:id) { 25 } # ピカチュウ

    it 'get pokemon data' do
      get api_pokemon_path(id), params: {region: 'kanto'}
      expect(response).to have_http_status(:success)
      expect(response.parsed_body).to match(
        {'id' => 25,
         'name' => 'ピカチュウ',
         'types' => [{'slot' => 1, 'name' => 'electric', }],
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
         'moves' => [
           {'name' => 'めいそう', 'level_learned_at' => 0, 'move_learn_method' => 'machine'},
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
           {'name' => 'かみなり', 'level_learned_at' => 30, 'move_learn_method' => 'level-up'}
         ],
         'version_group' => 'lets-go-pikachu-lets-go-eevee',
         'damage_from' => {
           'bug' => 1,
           'dark' => 1,
           'dragon' => 1,
           'electric' => 0.5,
           'fairy' => 1,
           'fighting' => 1,
           'fire' => 1,
           'flying' => 0.5,
           'ghost' => 1,
           'grass' => 1,
           'ground' => 2,
           'ice' => 1,
           'normal' => 1,
           'poison' => 1,
           'psychic' => 1,
           'rock' => 1,
           'steel' => 0.5,
           'water' => 1
         }}
      )
    end

    context 'get pokemon data whose version group is additional contents' do
      let(:id){ 1024 } # テラパゴス

      it do
        get api_pokemon_path(id), params: {region: 'paldea'}
        expect(response).to have_http_status(:success)
        expect(response.parsed_body).to match(
          {
            'damage_from' => {'bug' => 1, 'dark' => 1, 'dragon' => 1, 'electric' => 1, 'fairy' => 1, 'fighting' => 2, 'fire' => 1, 'flying' => 1, 'ghost' => 0, 'grass' => 1, 'ground' => 1, 'ice' => 1, 'normal' => 1, 'poison' => 1, 'psychic' => 1, 'rock' => 1, 'steel' => 1, 'water' => 1},
            'flavor_text' => nil,
            'id' => 1024,
            'moves' => [
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'ちょうおんぱ'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'のしかかり'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'とっしん'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'アイアンヘッド'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'ストーンエッジ'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'ステルスロック'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'ヘビースラム'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'アシストパワー'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'ワイルドボルト'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'ヒートスタンプ'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'マジカルシャイン'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'ボディプレス'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'メテオビーム'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'あなをほる'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'こおりのつむじ'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'すてみタックル'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'ほえる'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'かえんほうしゃ'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'なみのり'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'れいとうビーム'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'はかいこうせん'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'ソーラービーム'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => '１０まんボルト'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'かみなり'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'じしん'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'どくどく'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'ねむる'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'いわなだれ'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'みがわり'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'まもる'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'がまん'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'ねごと'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'あまごい'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'にほんばれ'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'かみくだく'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'からげんき'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'おおぞらほう'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'めいそう'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'みずのはどう'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'じゅうりょく'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'ジャイロボール'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'フレアドライブ'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'はどうだん'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'あくのはどう'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'むしのさざめき'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'りゅうのはどう'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'パワージェム'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'エナジーボール'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'だいちのちから'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'ギガインパクト'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'しねんのずつき'},
              {'level_learned_at' => 0, 'move_learn_method' => 'machine', 'name' => 'ラスターカノン'},
              {'level_learned_at' => 1, 'move_learn_method' => 'level-up', 'name' => 'からにこもる'},
              {'level_learned_at' => 1, 'move_learn_method' => 'level-up', 'name' => 'こうそくスピン'},
              {'level_learned_at' => 1, 'move_learn_method' => 'level-up', 'name' => 'トライアタック'},
              {'level_learned_at' => 10, 'move_learn_method' => 'level-up', 'name' => 'ねんぱつ'},
              {'level_learned_at' => 20, 'move_learn_method' => 'level-up', 'name' => 'ずつき'},
              {'level_learned_at' => 30, 'move_learn_method' => 'level-up', 'name' => 'まもる'},
              {'level_learned_at' => 40, 'move_learn_method' => 'level-up', 'name' => 'だいちのちから'},
              {'level_learned_at' => 50, 'move_learn_method' => 'level-up', 'name' => 'ヘビースラム'},
              {'level_learned_at' => 60, 'move_learn_method' => 'level-up', 'name' => 'てんそくせん'},
              {'level_learned_at' => 70, 'move_learn_method' => 'level-up', 'name' => 'すてみタックル'},
              {'level_learned_at' => 80, 'move_learn_method' => 'level-up', 'name' => 'ロックカット'},
              {'level_learned_at' => 90, 'move_learn_method' => 'level-up', 'name' => 'ジャイロボール'}
            ],
            'name' => 'テラパゴス',
            'sprites' => {
              'back_default' => nil,
              'back_female' => nil,
              'back_shiny' => nil,
              'back_shiny_female' => nil,
              'front_default' => 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1024.png',
              'front_female' => nil,
              'front_shiny' => 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1024.png',
              'front_shiny_female' => nil
            },
            'status' => {
              'attack' => {'base_stat' => 65, 'effort' => 0},
              'defense' => {'base_stat' => 85, 'effort' => 1},
              'hp' => {'base_stat' => 90, 'effort' => 0},
              'special_attack' => {'base_stat' => 65, 'effort' => 0},
              'special_defense' => {'base_stat' => 85, 'effort' => 0},
              'speed' => {'base_stat' => 60, 'effort' => 0}
            },
            'types' => [{'name' => 'normal', 'slot' => 1}],
            'version_group' => 'scarlet-violet'
          }
        )
      end
    end

    context 'get pokemon data which has moves with same names' do
      let(:id) { 3 } # フシギバナ

      it do
        get api_pokemon_path(id), params: {region: 'kanto'}
        expect(response).to have_http_status(:success)
        expect(response.parsed_body['moves']).to include(
          {'name' => 'はなびらのまい', 'level_learned_at' => 0, 'move_learn_method' => 'level-up'},
          {'name' => 'はなびらのまい', 'level_learned_at' => 1, 'move_learn_method' => 'level-up'}
        )
      end
    end

    context 'get pokemon data whose damage from has several values' do


      context 'magneton' do
        let(:id) { 82 } # レアコイル

        it do
          get api_pokemon_path(id), params: {region: 'kanto'}
          expect(response).to have_http_status(:success)
          expect(response.parsed_body['damage_from']).to eq(
            {
              'bug' => 0.5,
              'dark' => 1,
              'dragon' => 0.5,
              'electric' => 0.5,
              'fairy' => 0.5,
              'fighting' => 2,
              'fire' => 2,
              'flying' => 0.25,
              'ghost' => 1,
              'grass' => 0.5,
              'ground' => 4,
              'ice' => 0.5,
              'normal' => 0.5,
              'poison' => 0,
              'psychic' => 0.5,
              'rock' => 0.5,
              'steel' => 0.25,
              'water' => 1
            }
          )
        end
      end

      context 'quagsire' do
        let(:id) { 195 } # ヌオー

        it do
          get api_pokemon_path(id), params: {region: 'kanto'}
          expect(response).to have_http_status(:success)
          expect(response.parsed_body['damage_from']).to eq(
            {
              'bug' => 1,
              'dark' => 1,
              'dragon' => 1,
              'electric' => 0,
              'fairy' => 1,
              'fighting' => 1,
              'fire' => 0.5,
              'flying' => 1,
              'ghost' => 1,
              'grass' => 4,
              'ground' => 1,
              'ice' => 1,
              'normal' => 1,
              'poison' => 0.5,
              'psychic' => 1,
              'rock' => 0.5,
              'steel' => 0.5,
              'water' => 1
            }
          )
        end
      end

    end
  end
end
