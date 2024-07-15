# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pokemon', type: :request do
  describe '#index' do
    it 'get pokemon list', :vcr do
      get api_pokemons_path, params: {pokedexes: ['letsgo-kanto']}
      expect(response).to have_http_status(:success)
      body = response.parsed_body.first
      expect(body[:pokemons].size).to eq 153
      expect(body['pokemons']).to include(
        {
          'id' => 1,
          'name' => 'bulbasaur',
          'display_name' => 'フシギダネ',
          'pokedex_number' => 1
        },
        {
          'id' => 808,
          'name' => 'meltan',
          'display_name' => 'メルタン',
          'pokedex_number' => 152
        }
      )
    end
  end

  describe '#show', :vcr do
    let(:id) { 25 } # ピカチュウ

    it 'get pokemon data' do
      get api_pokemon_path(id), params: {version_group: 'lets-go-pikachu-lets-go-eevee'}
      expect(response).to have_http_status(:success)
      p response.parsed_body
      expect(response.parsed_body).to match(
        {
          'id' => 25,
          'name' => 'ピカチュウ',
          'types' => [{'slot' => 1, 'name' => 'でんき'}],
          'status' => [{'name' => 'hp', 'label' => 'HP', 'base_stat' => 35, 'effort' => 0}, {'name' => 'attack', 'label' => 'こうげき', 'base_stat' => 55, 'effort' => 0}, {'name' => 'defense', 'label' => 'ぼうぎょ', 'base_stat' => 40, 'effort' => 0}, {'name' => 'special_attack', 'label' => 'とくこう', 'base_stat' => 50, 'effort' => 0}, {'name' => 'special_defense', 'label' => 'とくぼう', 'base_stat' => 50, 'effort' => 0}, {'name' => 'speed', 'label' => 'すばやさ', 'base_stat' => 90, 'effort' => 2}],
          'sprites' => {'front_default' => 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png'},
          'abilities' => [{'name' => 'せいでんき', 'is_hidden' => false, 'flavor_text' => "静電気を　体に　まとい\n触った　相手を\nまひさせる　ことがある。"}, {'name' => 'ひらいしん', 'is_hidden' => true, 'flavor_text' => "でんきタイプの　技を　自分に\n寄せつけ　ダメージを　受けずに\n特攻が　上がる。"}],
          'flavor_text' => "森に　棲む　ポケモン。　ほっぺの\nふくろは　電気を　ためるので\n触ると　パチパチ　痺れるぞ。",
          'moves' => [{'id' => 45, 'move_learn_method' => 'level-up', 'level' => 1, 'name' => 'なきごえ', 'power' => nil, 'accuracy' => 100, 'pp' => 40, 'type' => 'ノーマル', 'flavor_text' => "かわいい　なきごえを　聞かせて\n気を　ひき　油断を　させて\n相手の　攻撃を　さげる。"}, {'id' => 84, 'move_learn_method' => 'level-up', 'level' => 1, 'name' => 'でんきショック', 'power' => 40, 'accuracy' => 100, 'pp' => 30, 'type' => 'でんき', 'flavor_text' => "電気の　刺激を\n相手に　浴びせて　攻撃する。\nまひ状態に　することが　ある。"}, {'id' => 39, 'move_learn_method' => 'level-up', 'level' => 3, 'name' => 'しっぽをふる', 'power' => nil, 'accuracy' => 100, 'pp' => 30, 'type' => 'ノーマル', 'flavor_text' => "しっぽを　左右に　かわいく　ふって\n油断を　誘う。\n相手の　防御を　さげる。"}, {'id' => 98, 'move_learn_method' => 'level-up', 'level' => 6, 'name' => 'でんこうせっか', 'power' => 40, 'accuracy' => 100, 'pp' => 30, 'type' => 'ノーマル', 'flavor_text' => "目にも　留まらぬ　ものすごい　速さで\n相手に　つっこむ。\n必ず　先制攻撃　できる。"}, {'id' => 24, 'move_learn_method' => 'level-up', 'level' => 9, 'name' => 'にどげり', 'power' => 30, 'accuracy' => 100, 'pp' => 30, 'type' => 'かくとう', 'flavor_text' => "２本の　足で　相手を　けとばして\n攻撃する。　２回連続で\nダメージを　与える。"}, {'id' => 104, 'move_learn_method' => 'level-up', 'level' => 12, 'name' => 'かげぶんしん', 'power' => nil, 'accuracy' => nil, 'pp' => 15, 'type' => 'ノーマル', 'flavor_text' => "素早い　動きで　分身を　つくり\n相手を　まどわせて\n回避率を　あげる。"}, {'id' => 86, 'move_learn_method' => 'level-up', 'level' => 15, 'name' => 'でんじは', 'power' => nil, 'accuracy' => 90, 'pp' => 20, 'type' => 'でんき', 'flavor_text' => "弱い　電撃を　浴びせることで\n相手を　まひ状態に　する。"}, {'id' => 113, 'move_learn_method' => 'level-up', 'level' => 18, 'name' => 'ひかりのかべ', 'power' => nil, 'accuracy' => nil, 'pp' => 30, 'type' => 'エスパー', 'flavor_text' => "５ターンの　間　不思議な　かべで\n相手から　受ける　特殊攻撃の\nダメージを　弱める。"}, {'id' => 85, 'move_learn_method' => 'level-up', 'level' => 21, 'name' => '１０まんボルト', 'power' => 90, 'accuracy' => 100, 'pp' => 15, 'type' => 'でんき', 'flavor_text' => "強い　電撃を\n相手に　浴びせて　攻撃する。\nまひ状態に　することが　ある。"}, {'id' => 21, 'move_learn_method' => 'level-up', 'level' => 24, 'name' => 'たたきつける', 'power' => 80, 'accuracy' => 75, 'pp' => 20, 'type' => 'ノーマル', 'flavor_text' => "長い　しっぽや　つるなどを　使い\n相手を　たたきつけて　攻撃する。"}, {'id' => 97, 'move_learn_method' => 'level-up', 'level' => 27, 'name' => 'こうそくいどう', 'power' => nil, 'accuracy' => nil, 'pp' => 30, 'type' => 'エスパー', 'flavor_text' => "力を　ぬいて　体を　軽くして\n高速で　動く。\n自分の　素早さを　ぐーんと　あげる。"}, {'id' => 87, 'move_learn_method' => 'level-up', 'level' => 30, 'name' => 'かみなり', 'power' => 110, 'accuracy' => 70, 'pp' => 10, 'type' => 'でんき', 'flavor_text' => "激しい　雷を\n相手に　落として　攻撃する。\nまひ状態に　することが　ある。"}, {'id' => 6, 'move_learn_method' => 'machine', 'level' => 0, 'name' => 'ネコにこばん', 'power' => 40, 'accuracy' => 100, 'pp' => 20, 'type' => 'ノーマル', 'flavor_text' => "相手の　体に\n小判を　投げつけて　攻撃する。\n戦闘の　あとで　お金が　もらえる。"}, {'id' => 9, 'move_learn_method' => 'machine', 'level' => 0, 'name' => 'かみなりパンチ', 'power' => 75, 'accuracy' => 100, 'pp' => 15, 'type' => 'でんき', 'flavor_text' => "電撃を　こめた　パンチで\n相手を　攻撃する。\nまひ状態に　することが　ある。"}, {'id' => 29, 'move_learn_method' => 'machine', 'level' => 0, 'name' => 'ずつき', 'power' => 70, 'accuracy' => 100, 'pp' => 15, 'type' => 'ノーマル', 'flavor_text' => "頭を　突きだして\nまっすぐ　つっこんで　攻撃する。\n相手を　ひるませることが　ある。"}, {'id' => 69, 'move_learn_method' => 'machine', 'level' => 0, 'name' => 'ちきゅうなげ', 'power' => nil, 'accuracy' => 100, 'pp' => 20, 'type' => 'かくとう', 'flavor_text' => "引力を　使い　投げとばす。\n自分の　レベルと　同じ　ダメージを\n相手に　与える。"}, {'id' => 85, 'move_learn_method' => 'machine', 'level' => 0, 'name' => '１０まんボルト', 'power' => 90, 'accuracy' => 100, 'pp' => 15, 'type' => 'でんき', 'flavor_text' => "強い　電撃を\n相手に　浴びせて　攻撃する。\nまひ状態に　することが　ある。"}, {'id' => 86, 'move_learn_method' => 'machine', 'level' => 0, 'name' => 'でんじは', 'power' => nil, 'accuracy' => 90, 'pp' => 20, 'type' => 'でんき', 'flavor_text' => "弱い　電撃を　浴びせることで\n相手を　まひ状態に　する。"}, {'id' => 87, 'move_learn_method' => 'machine', 'level' => 0, 'name' => 'かみなり', 'power' => 110, 'accuracy' => 70, 'pp' => 10, 'type' => 'でんき', 'flavor_text' => "激しい　雷を\n相手に　落として　攻撃する。\nまひ状態に　することが　ある。"}, {'id' => 91, 'move_learn_method' => 'machine', 'level' => 0, 'name' => 'あなをほる', 'power' => 80, 'accuracy' => 100, 'pp' => 10, 'type' => 'じめん', 'flavor_text' => "１ターン目に　潜り　２ターン目で\n相手を　攻撃する。"}, {'id' => 92, 'move_learn_method' => 'machine', 'level' => 0, 'name' => 'どくどく', 'power' => nil, 'accuracy' => 90, 'pp' => 10, 'type' => 'どく', 'flavor_text' => "相手を　猛毒の　状態に　する。\nターンが　すすむほど\n毒の　ダメージが　増えていく。"}, {'id' => 113, 'move_learn_method' => 'machine', 'level' => 0, 'name' => 'ひかりのかべ', 'power' => nil, 'accuracy' => nil, 'pp' => 30, 'type' => 'エスパー', 'flavor_text' => "５ターンの　間　不思議な　かべで\n相手から　受ける　特殊攻撃の\nダメージを　弱める。"}, {'id' => 115, 'move_learn_method' => 'machine', 'level' => 0, 'name' => 'リフレクター', 'power' => nil, 'accuracy' => nil, 'pp' => 20, 'type' => 'エスパー', 'flavor_text' => "５ターンの　間　不思議な　かべで\n相手から　受ける　物理攻撃の\nダメージを　弱める。"}, {'id' => 156, 'move_learn_method' => 'machine', 'level' => 0, 'name' => 'ねむる', 'power' => nil, 'accuracy' => nil, 'pp' => 5, 'type' => 'エスパー', 'flavor_text' => "２ターンの　間　眠り続ける。\n自分の　ＨＰと　状態異常を\nすべて　回復する。"}, {'id' => 164, 'move_learn_method' => 'machine', 'level' => 0, 'name' => 'みがわり', 'power' => nil, 'accuracy' => nil, 'pp' => 10, 'type' => 'ノーマル', 'flavor_text' => "自分の　ＨＰを　少し　削って\n分身を　だす。\n分身は　自分の　身代わりに　なる。"}, {'id' => 182, 'move_learn_method' => 'machine', 'level' => 0, 'name' => 'まもる', 'power' => nil, 'accuracy' => nil, 'pp' => 10, 'type' => 'ノーマル', 'flavor_text' => "相手の　攻撃を\nまったく　受けない。\n連続で　だすと　失敗しやすい。"}, {'id' => 231, 'move_learn_method' => 'machine', 'level' => 0, 'name' => 'アイアンテール', 'power' => 100, 'accuracy' => 75, 'pp' => 15, 'type' => 'はがね', 'flavor_text' => "硬い　しっぽで\n相手を　たたきつけて　攻撃する。\n相手の　防御を　さげることが　ある。"}, {'id' => 263, 'move_learn_method' => 'machine', 'level' => 0, 'name' => 'からげんき', 'power' => 70, 'accuracy' => 100, 'pp' => 20, 'type' => 'ノーマル', 'flavor_text' => "自分が　毒　まひ　やけど\n状態のとき　相手に　くりだすと\n技の　威力が　２倍に　なる。"}, {'id' => 270, 'move_learn_method' => 'machine', 'level' => 0, 'name' => 'てだすけ', 'power' => nil, 'accuracy' => nil, 'pp' => 20, 'type' => 'ノーマル', 'flavor_text' => "仲間を　助ける。\nてだすけ　された　ポケモンの　技の\n威力は　いつもより　大きくなる。"}, {'id' => 280, 'move_learn_method' => 'machine', 'level' => 0, 'name' => 'かわらわり', 'power' => 75, 'accuracy' => 100, 'pp' => 15, 'type' => 'かくとう', 'flavor_text' => "手刀を　勢いよく　振りおろして\n相手を　攻撃する。　ひかりのかべや\nリフレクター　なども　破壊できる。"}, {'id' => 347, 'move_learn_method' => 'machine', 'level' => 0, 'name' => 'めいそう', 'power' => nil, 'accuracy' => nil, 'pp' => 20, 'type' => 'エスパー', 'flavor_text' => "静かに　精神を　統一し\n心を　鎮めることで　自分の\n特攻と　特防を　あげる。"}],
          'damage_from' => {'normal' => 1.0, 'fighting' => 1.0, 'flying' => 0.5, 'poison' => 1.0, 'ground' => 2.0, 'rock' => 1.0, 'bug' => 1.0, 'ghost' => 1.0, 'steel' => 0.5, 'fire' => 1.0, 'water' => 1.0, 'grass' => 1.0, 'electric' => 0.5, 'psychic' => 1.0, 'ice' => 1.0, 'dragon' => 1.0, 'dark' => 1.0, 'fairy' => 1.0}
        }
      )
    end

    context 'get pokemon data whose version group is additional contents' do
      let(:id){ 1024 } # テラパゴス

      it do
        get api_pokemon_path(id), params: {version_group: 'scarlet-violet'}
        expect(response).to have_http_status(:success)
        expect(response.parsed_body).to match(
          {
            'damage_from' => {'bug' => 1.0, 'dark' => 1.0, 'dragon' => 1.0, 'electric' => 1.0, 'fairy' => 1.0, 'fighting' => 2.0, 'fire' => 1.0, 'flying' => 1.0, 'ghost' => 0.0, 'grass' => 1.0, 'ground' => 1.0, 'ice' => 1.0, 'normal' => 1.0, 'poison' => 1.0, 'psychic' => 1.0, 'rock' => 1.0, 'steel' => 1.0, 'water' => 1.0},
            'flavor_text' => nil,
            'id' => 1024,
            'moves' => [{'accuracy' => nil, 'flavor_text' => nil, 'id' => 110, 'level' => 1, 'move_learn_method' => 'level-up', 'name' => 'からにこもる', 'power' => nil, 'pp' => 40, 'type' => 'みず'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 161, 'level' => 1, 'move_learn_method' => 'level-up', 'name' => 'トライアタック', 'power' => 80, 'pp' => 10, 'type' => 'ノーマル'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 229, 'level' => 1, 'move_learn_method' => 'level-up', 'name' => 'こうそくスピン', 'power' => 50, 'pp' => 40, 'type' => 'ノーマル'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 246, 'level' => 10, 'move_learn_method' => 'level-up', 'name' => 'げんしのちから', 'power' => 60, 'pp' => 5, 'type' => 'いわ'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 29, 'level' => 20, 'move_learn_method' => 'level-up', 'name' => 'ずつき', 'power' => 70, 'pp' => 15, 'type' => 'ノーマル'}, {'accuracy' => nil, 'flavor_text' => nil, 'id' => 182, 'level' => 30, 'move_learn_method' => 'level-up', 'name' => 'まもる', 'power' => nil, 'pp' => 10, 'type' => 'ノーマル'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 414, 'level' => 40, 'move_learn_method' => 'level-up', 'name' => 'だいちのちから', 'power' => 90, 'pp' => 10, 'type' => 'じめん'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 484, 'level' => 50, 'move_learn_method' => 'level-up', 'name' => 'ヘビーボンバー', 'power' => nil, 'pp' => 10, 'type' => 'はがね'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 906, 'level' => 60, 'move_learn_method' => 'level-up', 'name' => 'テラクラスター', 'power' => 120, 'pp' => 5, 'type' => 'ノーマル'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 38, 'level' => 70, 'move_learn_method' => 'level-up', 'name' => 'すてみタックル', 'power' => 120, 'pp' => 15, 'type' => 'ノーマル'}, {'accuracy' => nil, 'flavor_text' => nil, 'id' => 397, 'level' => 80, 'move_learn_method' => 'level-up', 'name' => 'ロックカット', 'power' => nil, 'pp' => 20, 'type' => 'いわ'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 360, 'level' => 90, 'move_learn_method' => 'level-up', 'name' => 'ジャイロボール', 'power' => nil, 'pp' => 5, 'type' => 'はがね'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 34, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'のしかかり', 'power' => 85, 'pp' => 15, 'type' => 'ノーマル'}, {'accuracy' => 85, 'flavor_text' => nil, 'id' => 36, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'とっしん', 'power' => 90, 'pp' => 20, 'type' => 'ノーマル'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 38, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'すてみタックル', 'power' => 120, 'pp' => 15, 'type' => 'ノーマル'}, {'accuracy' => nil, 'flavor_text' => nil, 'id' => 46, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'ほえる', 'power' => nil, 'pp' => 20, 'type' => 'ノーマル'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 53, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'かえんほうしゃ', 'power' => 90, 'pp' => 15, 'type' => 'ほのお'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 57, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'なみのり', 'power' => 90, 'pp' => 15, 'type' => 'みず'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 58, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'れいとうビーム', 'power' => 90, 'pp' => 10, 'type' => 'こおり'}, {'accuracy' => 90, 'flavor_text' => nil, 'id' => 63, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'はかいこうせん', 'power' => 150, 'pp' => 5, 'type' => 'ノーマル'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 76, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'ソーラービーム', 'power' => 120, 'pp' => 10, 'type' => 'くさ'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 85, 'level' => 0, 'move_learn_method' => 'machine', 'name' => '１０まんボルト', 'power' => 90, 'pp' => 15, 'type' => 'でんき'}, {'accuracy' => 70, 'flavor_text' => nil, 'id' => 87, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'かみなり', 'power' => 110, 'pp' => 10, 'type' => 'でんき'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 89, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'じしん', 'power' => 100, 'pp' => 10, 'type' => 'じめん'}, {'accuracy' => 90, 'flavor_text' => nil, 'id' => 92, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'どくどく', 'power' => nil, 'pp' => 10, 'type' => 'どく'}, {'accuracy' => nil, 'flavor_text' => nil, 'id' => 156, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'ねむる', 'power' => nil, 'pp' => 5, 'type' => 'エスパー'}, {'accuracy' => 90, 'flavor_text' => nil, 'id' => 157, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'いわなだれ', 'power' => 75, 'pp' => 10, 'type' => 'いわ'}, {'accuracy' => nil, 'flavor_text' => nil, 'id' => 164, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'みがわり', 'power' => nil, 'pp' => 10, 'type' => 'ノーマル'}, {'accuracy' => nil, 'flavor_text' => nil, 'id' => 182, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'まもる', 'power' => nil, 'pp' => 10, 'type' => 'ノーマル'}, {'accuracy' => nil, 'flavor_text' => nil, 'id' => 203, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'こらえる', 'power' => nil, 'pp' => 10, 'type' => 'ノーマル'}, {'accuracy' => nil, 'flavor_text' => nil, 'id' => 214, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'ねごと', 'power' => nil, 'pp' => 10, 'type' => 'ノーマル'}, {'accuracy' => nil, 'flavor_text' => nil, 'id' => 240, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'あまごい', 'power' => nil, 'pp' => 5, 'type' => 'みず'}, {'accuracy' => nil, 'flavor_text' => nil, 'id' => 241, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'にほんばれ', 'power' => nil, 'pp' => 5, 'type' => 'ほのお'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 242, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'かみくだく', 'power' => 80, 'pp' => 15, 'type' => 'あく'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 263, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'からげんき', 'power' => 70, 'pp' => 20, 'type' => 'ノーマル'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 311, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'ウェザーボール', 'power' => 50, 'pp' => 10, 'type' => 'ノーマル'}, {'accuracy' => nil, 'flavor_text' => nil, 'id' => 347, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'めいそう', 'power' => nil, 'pp' => 20, 'type' => 'エスパー'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 352, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'みずのはどう', 'power' => 60, 'pp' => 20, 'type' => 'みず'}, {'accuracy' => nil, 'flavor_text' => nil, 'id' => 356, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'じゅうりょく', 'power' => nil, 'pp' => 5, 'type' => 'エスパー'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 360, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'ジャイロボール', 'power' => nil, 'pp' => 5, 'type' => 'はがね'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 394, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'フレアドライブ', 'power' => 120, 'pp' => 15, 'type' => 'ほのお'}, {'accuracy' => nil, 'flavor_text' => nil, 'id' => 396, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'はどうだん', 'power' => 80, 'pp' => 20, 'type' => 'かくとう'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 399, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'あくのはどう', 'power' => 80, 'pp' => 15, 'type' => 'あく'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 405, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'むしのさざめき', 'power' => 90, 'pp' => 10, 'type' => 'むし'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 406, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'りゅうのはどう', 'power' => 85, 'pp' => 10, 'type' => 'ドラゴン'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 408, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'パワージェム', 'power' => 80, 'pp' => 20, 'type' => 'いわ'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 412, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'エナジーボール', 'power' => 90, 'pp' => 10, 'type' => 'くさ'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 414, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'だいちのちから', 'power' => 90, 'pp' => 10, 'type' => 'じめん'}, {'accuracy' => 90, 'flavor_text' => nil, 'id' => 416, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'ギガインパクト', 'power' => 150, 'pp' => 5, 'type' => 'ノーマル'}, {'accuracy' => 90, 'flavor_text' => nil, 'id' => 428, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'しねんのずつき', 'power' => 80, 'pp' => 15, 'type' => 'エスパー'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 430, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'ラスターカノン', 'power' => 80, 'pp' => 10, 'type' => 'はがね'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 442, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'アイアンヘッド', 'power' => 80, 'pp' => 15, 'type' => 'はがね'}, {'accuracy' => 80, 'flavor_text' => nil, 'id' => 444, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'ストーンエッジ', 'power' => 100, 'pp' => 5, 'type' => 'いわ'}, {'accuracy' => nil, 'flavor_text' => nil, 'id' => 446, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'ステルスロック', 'power' => nil, 'pp' => 20, 'type' => 'いわ'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 484, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'ヘビーボンバー', 'power' => nil, 'pp' => 10, 'type' => 'はがね'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 500, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'アシストパワー', 'power' => 20, 'pp' => 10, 'type' => 'エスパー'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 528, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'ワイルドボルト', 'power' => 90, 'pp' => 15, 'type' => 'でんき'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 535, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'ヒートスタンプ', 'power' => nil, 'pp' => 10, 'type' => 'ほのお'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 605, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'マジカルシャイン', 'power' => 80, 'pp' => 10, 'type' => 'フェアリー'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 776, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'ボディプレス', 'power' => 80, 'pp' => 10, 'type' => 'かくとう'}, {'accuracy' => 90, 'flavor_text' => nil, 'id' => 800, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'メテオビーム', 'power' => 120, 'pp' => 10, 'type' => 'いわ'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 815, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'ねっさのだいち', 'power' => 70, 'pp' => 10, 'type' => 'じめん'}, {'accuracy' => 100, 'flavor_text' => nil, 'id' => 861, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'アイススピナー', 'power' => 80, 'pp' => 15, 'type' => 'こおり'}, {'accuracy' => 95, 'flavor_text' => nil, 'id' => 916, 'level' => 0, 'move_learn_method' => 'machine', 'name' => 'サンダーダイブ', 'power' => 100, 'pp' => 15, 'type' => 'でんき'}],
            'name' => 'テラパゴス',
            'sprites' => {'front_default' => 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1024.png'},
            'status' => [
              {'base_stat' => 90, 'effort' => 0, 'label' => 'HP', 'name' => 'hp'},
              {'base_stat' => 65, 'effort' => 0, 'label' => 'こうげき', 'name' => 'attack'},
              {'base_stat' => 85, 'effort' => 1, 'label' => 'ぼうぎょ', 'name' => 'defense'},
              {'base_stat' => 65, 'effort' => 0, 'label' => 'とくこう', 'name' => 'special_attack'},
              {'base_stat' => 85, 'effort' => 0, 'label' => 'とくぼう', 'name' => 'special_defense'},
              {'base_stat' => 60, 'effort' => 0, 'label' => 'すばやさ', 'name' => 'speed'}
            ],
            'types' => [{'name' => 'ノーマル', 'slot' => 1}],
            'abilities' => [{'flavor_text' => nil, 'is_hidden' => false, 'name' => 'テラスチェンジ'}],
          }
        )
      end
    end

    context 'get pokemon data which has moves with same names' do
      let(:id) { 3 } # フシギバナ

      it do
        get api_pokemon_path(id), params: {version_group: 'lets-go-pikachu-lets-go-eevee'}
        expect(response).to have_http_status(:success)
        expect(response.parsed_body['moves']).to include(
          {'id' => 80, 'accuracy' => 100, 'power' => 120, 'pp' => 10, 'type' => 'くさ', 'name' => 'はなびらのまい', 'level' => 0, 'move_learn_method' => 'level-up', 'flavor_text' => "２ー３ターンの　間　花を\nまきちらして　相手を　攻撃する。\nまきちらした　あとは　混乱する。", },
          {'id' => 80, 'accuracy' => 100, 'power' => 120, 'pp' => 10, 'type' => 'くさ', 'name' => 'はなびらのまい', 'level' => 1, 'move_learn_method' => 'level-up', 'flavor_text' => "２ー３ターンの　間　花を\nまきちらして　相手を　攻撃する。\nまきちらした　あとは　混乱する。", }
        )
      end
    end

    context 'get pokemon data whose damage from has several values' do


      context 'magneton' do
        let(:id) { 82 } # レアコイル

        it do
          get api_pokemon_path(id), params: {version_group: 'lets-go-pikachu-lets-go-eevee'}
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
          get api_pokemon_path(id), params: {version_group: 'lets-go-pikachu-lets-go-eevee'}
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

    context 'get pokemon data when ability flavor text is empty' do
      let(:id){ 1024 } # テラパゴス

      it do
        get api_pokemon_path(id), params: {version_group: 'scarlet-violet'}
        expect(response).to have_http_status(:success)
        expect(response.parsed_body[:abilities]).to contain_exactly({'flavor_text' => nil, 'is_hidden' => false, 'name' => 'テラスチェンジ'})
      end
    end

    context 'not found error when main version group is invalid' do
      it do
        get api_pokemon_path(id), params: {version_group: 'the-teal-mask'}
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe '#form', :vcr do
    context 'when there are some forms' do
      let(:id) { 3 } # フシギバナ

      context 'when mega is valid' do
        it do
          get forms_api_pokemon_path(id), params: {version_group: 'lets-go-pikachu-lets-go-eevee'}
          expect(response).to have_http_status(:success)
          expect(response.parsed_body).to match(
            forms: [
              {
                id: 10033,
                name: 'メガフシギバナ',
                is_in_version_group: true
              },
              {
                id: 10195,
                name: 'キョダイマックスフシギバナ',
                is_in_version_group: false
              }
            ]
          )
        end
      end

      context 'when gmax is valid' do
        it do
          get forms_api_pokemon_path(id), params: {version_group: 'sword-shield'}
          expect(response).to have_http_status(:success)
          expect(response.parsed_body).to match(
            forms: [
              {
                id: 10033,
                name: 'メガフシギバナ',
                is_in_version_group: false
              },
              {
                id: 10195,
                name: 'キョダイマックスフシギバナ',
                is_in_version_group: true
              }
            ]
          )
        end
      end

      context 'when sugata is valid in version group' do
        let(:id) { 128 } # ケンタロス

        it  do
          get forms_api_pokemon_path(id), params: {version_group: 'scarlet-violet'}
          expect(response).to have_http_status(:success)
          expect(response.parsed_body).to match(
            forms: [
              {
                id: 10250,
                name: 'ケンタロス (パルデアのすがた・コンバットしゅ)',
                is_in_version_group: true
              },
              {
                id: 10251,
                name: 'ケンタロス (パルデアのすがた・ブレイズしゅ)',
                is_in_version_group: true
              },
              {
                id: 10252,
                name: 'ケンタロス (パルデアのすがた・ウォーターしゅ)',
                is_in_version_group: true
              }
            ]
          )
        end
      end

      context 'when sugata is invalid in version group' do
        let(:id) { 128 } # ケンタロス

        it  do
          get forms_api_pokemon_path(id), params: {version_group: 'lets-go-pikachu-lets-go-eevee'}
          expect(response).to have_http_status(:success)
          expect(response.parsed_body).to match(
            forms: [
              {
                id: 10250,
                name: 'ケンタロス (パルデアのすがた・コンバットしゅ)',
                is_in_version_group: false
              },
              {
                id: 10251,
                name: 'ケンタロス (パルデアのすがた・ブレイズしゅ)',
                is_in_version_group: false
              },
              {
                id: 10252,
                name: 'ケンタロス (パルデアのすがた・ウォーターしゅ)',
                is_in_version_group: false
              }
            ]
          )
        end
      end
    end
  end

  describe '#evolution_chain', :vcr do
    let(:id) { 25 } # ピカチュウ

    it 'get evolution chain' do
      get evolution_chain_api_pokemon_path(id), params: {version_group: 'lets-go-pikachu-lets-go-eevee'}
      expect(response).to have_http_status(:success)
      expect(response.parsed_body).to match(
        {
          'evolution_chain' => {
            'evolution_details' => [],
            'evolves_to' => [
              {
                'evolution_details' => [
                  {
                    'gender' => nil,
                    'held_item' => nil,
                    'item' => nil,
                    'known_move' => nil,
                    'known_move_type' => nil,
                    'location' => nil,
                    'min_affection' => nil,
                    'min_beauty' => nil,
                    'min_happiness' => 220,
                    'min_level' => nil,
                    'needs_overworld_rain' => false,
                    'party_species' => nil,
                    'party_type' => nil,
                    'relative_physical_stats' => nil,
                    'time_of_day' => '',
                    'trade_species' => nil,
                    'trigger' => {'name' => 'level-up', 'url' => 'https://pokeapi.co/api/v2/evolution-trigger/1/'}, 'turn_upside_down' => false
                  }
                ],
                'evolves_to' => [
                  {
                    'evolution_details' => [
                      {'gender' => nil,
                       'held_item' => nil,
                       'item' => {
                         'name' => 'thunder-stone',
                         'url' => 'https://pokeapi.co/api/v2/item/83/'
                       },
                       'known_move' => nil,
                       'known_move_type' => nil,
                       'location' => nil,
                       'min_affection' => nil,
                       'min_beauty' => nil,
                       'min_happiness' => nil,
                       'min_level' => nil,
                       'needs_overworld_rain' => false,
                       'party_species' => nil,
                       'party_type' => nil,
                       'relative_physical_stats' => nil,
                       'time_of_day' => '',
                       'trade_species' => nil,
                       'trigger' => {'name' => 'use-item', 'url' => 'https://pokeapi.co/api/v2/evolution-trigger/3/'}, 'turn_upside_down' => false}
                    ], 'evolves_to' => [], 'id' => 26, 'is_baby' => false, 'is_in_version_group' => true, 'name' => 'ライチュウ'
                  }
                ], 'id' => 25, 'is_baby' => false, 'is_in_version_group' => true, 'name' => 'ピカチュウ'
              }
            ], 'id' => 172, 'is_baby' => true, 'is_in_version_group' => false, 'name' => 'ピチュー'
          }
        }
      )
    end

    context 'get pokemon data whose has some evolution chains' do
      let(:id){ 133 } # イーブイ

      context 'version_group is lets-go-pikachu-lets-go-eevee' do
        let(:version_group){ 'lets-go-pikachu-lets-go-eevee' }

        it do
          get evolution_chain_api_pokemon_path(id), params: {version_group: version_group}
          expect(response).to have_http_status(:success)
          expect(response.parsed_body['evolution_chain']).to eq(
            {'id' => 133,
             'name' => 'イーブイ',
             'is_baby' => false,
             'evolution_details' => [],
             'evolves_to' =>
             [{'id' => 134,
               'name' => 'シャワーズ',
               'is_baby' => false,
               'evolution_details' =>
                [{'item' => {'name' => 'water-stone', 'url' => 'https://pokeapi.co/api/v2/item/84/'},
                  'trigger' => {'name' => 'use-item', 'url' => 'https://pokeapi.co/api/v2/evolution-trigger/3/'},
                  'gender' => nil,
                  'held_item' => nil,
                  'known_move' => nil,
                  'known_move_type' => nil,
                  'location' => nil,
                  'min_level' => nil,
                  'min_happiness' => nil,
                  'min_beauty' => nil,
                  'min_affection' => nil,
                  'needs_overworld_rain' => false,
                  'party_species' => nil,
                  'party_type' => nil,
                  'relative_physical_stats' => nil,
                  'time_of_day' => '',
                  'trade_species' => nil,
                  'turn_upside_down' => false}],
               'evolves_to' => [],
               'is_in_version_group' => true},
              {'id' => 135,
               'name' => 'サンダース',
               'is_baby' => false,
               'evolution_details' =>
                [{'item' => {'name' => 'thunder-stone', 'url' => 'https://pokeapi.co/api/v2/item/83/'},
                  'trigger' => {'name' => 'use-item', 'url' => 'https://pokeapi.co/api/v2/evolution-trigger/3/'},
                  'gender' => nil,
                  'held_item' => nil,
                  'known_move' => nil,
                  'known_move_type' => nil,
                  'location' => nil,
                  'min_level' => nil,
                  'min_happiness' => nil,
                  'min_beauty' => nil,
                  'min_affection' => nil,
                  'needs_overworld_rain' => false,
                  'party_species' => nil,
                  'party_type' => nil,
                  'relative_physical_stats' => nil,
                  'time_of_day' => '',
                  'trade_species' => nil,
                  'turn_upside_down' => false}],
               'evolves_to' => [],
               'is_in_version_group' => true},
              {'id' => 136,
               'name' => 'ブースター',
               'is_baby' => false,
               'evolution_details' =>
                [{'item' => {'name' => 'fire-stone', 'url' => 'https://pokeapi.co/api/v2/item/82/'},
                  'trigger' => {'name' => 'use-item', 'url' => 'https://pokeapi.co/api/v2/evolution-trigger/3/'},
                  'gender' => nil,
                  'held_item' => nil,
                  'known_move' => nil,
                  'known_move_type' => nil,
                  'location' => nil,
                  'min_level' => nil,
                  'min_happiness' => nil,
                  'min_beauty' => nil,
                  'min_affection' => nil,
                  'needs_overworld_rain' => false,
                  'party_species' => nil,
                  'party_type' => nil,
                  'relative_physical_stats' => nil,
                  'time_of_day' => '',
                  'trade_species' => nil,
                  'turn_upside_down' => false}],
               'evolves_to' => [],
               'is_in_version_group' => true},
              {'id' => 196,
               'name' => 'エーフィ',
               'is_baby' => false,
               'evolution_details' =>
                [{'item' => nil,
                  'trigger' => {'name' => 'level-up', 'url' => 'https://pokeapi.co/api/v2/evolution-trigger/1/'},
                  'gender' => nil,
                  'held_item' => nil,
                  'known_move' => nil,
                  'known_move_type' => nil,
                  'location' => nil,
                  'min_level' => nil,
                  'min_happiness' => 160,
                  'min_beauty' => nil,
                  'min_affection' => nil,
                  'needs_overworld_rain' => false,
                  'party_species' => nil,
                  'party_type' => nil,
                  'relative_physical_stats' => nil,
                  'time_of_day' => 'day',
                  'trade_species' => nil,
                  'turn_upside_down' => false}],
               'evolves_to' => [],
               'is_in_version_group' => false},
              {'id' => 197,
               'name' => 'ブラッキー',
               'is_baby' => false,
               'evolution_details' =>
                [{'item' => nil,
                  'trigger' => {'name' => 'level-up', 'url' => 'https://pokeapi.co/api/v2/evolution-trigger/1/'},
                  'gender' => nil,
                  'held_item' => nil,
                  'known_move' => nil,
                  'known_move_type' => nil,
                  'location' => nil,
                  'min_level' => nil,
                  'min_happiness' => 160,
                  'min_beauty' => nil,
                  'min_affection' => nil,
                  'needs_overworld_rain' => false,
                  'party_species' => nil,
                  'party_type' => nil,
                  'relative_physical_stats' => nil,
                  'time_of_day' => 'night',
                  'trade_species' => nil,
                  'turn_upside_down' => false}],
               'evolves_to' => [],
               'is_in_version_group' => false},
              {'id' => 470,
               'name' => 'リーフィア',
               'is_baby' => false,
               'evolution_details' =>
                [{'item' => nil,
                  'trigger' => {'name' => 'level-up', 'url' => 'https://pokeapi.co/api/v2/evolution-trigger/1/'},
                  'gender' => nil,
                  'held_item' => nil,
                  'known_move' => nil,
                  'known_move_type' => nil,
                  'location' => {'name' => 'eterna-forest', 'url' => 'https://pokeapi.co/api/v2/location/8/'},
                  'min_level' => nil,
                  'min_happiness' => nil,
                  'min_beauty' => nil,
                  'min_affection' => nil,
                  'needs_overworld_rain' => false,
                  'party_species' => nil,
                  'party_type' => nil,
                  'relative_physical_stats' => nil,
                  'time_of_day' => '',
                  'trade_species' => nil,
                  'turn_upside_down' => false},
                 {'item' => nil,
                  'trigger' => {'name' => 'level-up', 'url' => 'https://pokeapi.co/api/v2/evolution-trigger/1/'},
                  'gender' => nil,
                  'held_item' => nil,
                  'known_move' => nil,
                  'known_move_type' => nil,
                  'location' => {'name' => 'pinwheel-forest', 'url' => 'https://pokeapi.co/api/v2/location/375/'},
                  'min_level' => nil,
                  'min_happiness' => nil,
                  'min_beauty' => nil,
                  'min_affection' => nil,
                  'needs_overworld_rain' => false,
                  'party_species' => nil,
                  'party_type' => nil,
                  'relative_physical_stats' => nil,
                  'time_of_day' => '',
                  'trade_species' => nil,
                  'turn_upside_down' => false},
                 {'item' => nil,
                  'trigger' => {'name' => 'level-up', 'url' => 'https://pokeapi.co/api/v2/evolution-trigger/1/'},
                  'gender' => nil,
                  'held_item' => nil,
                  'known_move' => nil,
                  'known_move_type' => nil,
                  'location' => {'name' => 'kalos-route-20', 'url' => 'https://pokeapi.co/api/v2/location/650/'},
                  'min_level' => nil,
                  'min_happiness' => nil,
                  'min_beauty' => nil,
                  'min_affection' => nil,
                  'needs_overworld_rain' => false,
                  'party_species' => nil,
                  'party_type' => nil,
                  'relative_physical_stats' => nil,
                  'time_of_day' => '',
                  'trade_species' => nil,
                  'turn_upside_down' => false},
                 {'item' => {'name' => 'leaf-stone', 'url' => 'https://pokeapi.co/api/v2/item/85/'},
                  'trigger' => {'name' => 'use-item', 'url' => 'https://pokeapi.co/api/v2/evolution-trigger/3/'},
                  'gender' => nil,
                  'held_item' => nil,
                  'known_move' => nil,
                  'known_move_type' => nil,
                  'location' => nil,
                  'min_level' => nil,
                  'min_happiness' => nil,
                  'min_beauty' => nil,
                  'min_affection' => nil,
                  'needs_overworld_rain' => false,
                  'party_species' => nil,
                  'party_type' => nil,
                  'relative_physical_stats' => nil,
                  'time_of_day' => '',
                  'trade_species' => nil,
                  'turn_upside_down' => false}],
               'evolves_to' => [],
               'is_in_version_group' => false},
              {'id' => 471,
               'name' => 'グレイシア',
               'is_baby' => false,
               'evolution_details' =>
                [{'item' => nil,
                  'trigger' => {'name' => 'level-up', 'url' => 'https://pokeapi.co/api/v2/evolution-trigger/1/'},
                  'gender' => nil,
                  'held_item' => nil,
                  'known_move' => nil,
                  'known_move_type' => nil,
                  'location' => {'name' => 'sinnoh-route-217', 'url' => 'https://pokeapi.co/api/v2/location/48/'},
                  'min_level' => nil,
                  'min_happiness' => nil,
                  'min_beauty' => nil,
                  'min_affection' => nil,
                  'needs_overworld_rain' => false,
                  'party_species' => nil,
                  'party_type' => nil,
                  'relative_physical_stats' => nil,
                  'time_of_day' => '',
                  'trade_species' => nil,
                  'turn_upside_down' => false},
                 {'item' => nil,
                  'trigger' => {'name' => 'level-up', 'url' => 'https://pokeapi.co/api/v2/evolution-trigger/1/'},
                  'gender' => nil,
                  'held_item' => nil,
                  'known_move' => nil,
                  'known_move_type' => nil,
                  'location' => {'name' => 'twist-mountain', 'url' => 'https://pokeapi.co/api/v2/location/380/'},
                  'min_level' => nil,
                  'min_happiness' => nil,
                  'min_beauty' => nil,
                  'min_affection' => nil,
                  'needs_overworld_rain' => false,
                  'party_species' => nil,
                  'party_type' => nil,
                  'relative_physical_stats' => nil,
                  'time_of_day' => '',
                  'trade_species' => nil,
                  'turn_upside_down' => false},
                 {'item' => nil,
                  'trigger' => {'name' => 'level-up', 'url' => 'https://pokeapi.co/api/v2/evolution-trigger/1/'},
                  'gender' => nil,
                  'held_item' => nil,
                  'known_move' => nil,
                  'known_move_type' => nil,
                  'location' => {'name' => 'frost-cavern', 'url' => 'https://pokeapi.co/api/v2/location/640/'},
                  'min_level' => nil,
                  'min_happiness' => nil,
                  'min_beauty' => nil,
                  'min_affection' => nil,
                  'needs_overworld_rain' => false,
                  'party_species' => nil,
                  'party_type' => nil,
                  'relative_physical_stats' => nil,
                  'time_of_day' => '',
                  'trade_species' => nil,
                  'turn_upside_down' => false},
                 {'item' => {'name' => 'ice-stone', 'url' => 'https://pokeapi.co/api/v2/item/885/'},
                  'trigger' => {'name' => 'use-item', 'url' => 'https://pokeapi.co/api/v2/evolution-trigger/3/'},
                  'gender' => nil,
                  'held_item' => nil,
                  'known_move' => nil,
                  'known_move_type' => nil,
                  'location' => nil,
                  'min_level' => nil,
                  'min_happiness' => nil,
                  'min_beauty' => nil,
                  'min_affection' => nil,
                  'needs_overworld_rain' => false,
                  'party_species' => nil,
                  'party_type' => nil,
                  'relative_physical_stats' => nil,
                  'time_of_day' => '',
                  'trade_species' => nil,
                  'turn_upside_down' => false}],
               'evolves_to' => [],
               'is_in_version_group' => false},
              {'id' => 700,
               'name' => 'ニンフィア',
               'is_baby' => false,
               'evolution_details' =>
                [{'item' => nil,
                  'trigger' => {'name' => 'level-up', 'url' => 'https://pokeapi.co/api/v2/evolution-trigger/1/'},
                  'gender' => nil,
                  'held_item' => nil,
                  'known_move' => nil,
                  'known_move_type' => {'name' => 'fairy', 'url' => 'https://pokeapi.co/api/v2/type/18/'},
                  'location' => nil,
                  'min_level' => nil,
                  'min_happiness' => nil,
                  'min_beauty' => nil,
                  'min_affection' => 2,
                  'needs_overworld_rain' => false,
                  'party_species' => nil,
                  'party_type' => nil,
                  'relative_physical_stats' => nil,
                  'time_of_day' => '',
                  'trade_species' => nil,
                  'turn_upside_down' => false},
                 {'item' => nil,
                  'trigger' => {'name' => 'level-up', 'url' => 'https://pokeapi.co/api/v2/evolution-trigger/1/'},
                  'gender' => nil,
                  'held_item' => nil,
                  'known_move' => nil,
                  'known_move_type' => {'name' => 'fairy', 'url' => 'https://pokeapi.co/api/v2/type/18/'},
                  'location' => nil,
                  'min_level' => nil,
                  'min_happiness' => 160,
                  'min_beauty' => nil,
                  'min_affection' => nil,
                  'needs_overworld_rain' => false,
                  'party_species' => nil,
                  'party_type' => nil,
                  'relative_physical_stats' => nil,
                  'time_of_day' => '',
                  'trade_species' => nil,
                  'turn_upside_down' => false}],
               'evolves_to' => [],
               'is_in_version_group' => false}],
             'is_in_version_group' => true}
          )
        end
      end
    end

    context 'get pokemon data whose has some evolution chains in additional contents' do
      let(:id){ 1 } # フシギダネ
      let(:version_group){ 'scarlet-violet' }

        it do
          get evolution_chain_api_pokemon_path(id), params: {version_group: version_group}
          expect(response).to have_http_status(:success)
          expect(response.parsed_body['evolution_chain']).to eq(
            {
              'id' => 1,
              'name' => 'フシギダネ',
              'is_baby' => false,
              'evolution_details' => [],
              'evolves_to' =>
                [{'id' => 2,
                  'name' => 'フシギソウ',
                  'is_baby' => false,
                  'evolution_details' =>
                    [{'item' => nil,
                      'trigger' => {'name' => 'level-up', 'url' => 'https://pokeapi.co/api/v2/evolution-trigger/1/'},
                      'gender' => nil,
                      'held_item' => nil,
                      'known_move' => nil,
                      'known_move_type' => nil,
                      'location' => nil,
                      'min_level' => 16,
                      'min_happiness' => nil,
                      'min_beauty' => nil,
                      'min_affection' => nil,
                      'needs_overworld_rain' => false,
                      'party_species' => nil,
                      'party_type' => nil,
                      'relative_physical_stats' => nil,
                      'time_of_day' => '',
                      'trade_species' => nil,
                      'turn_upside_down' => false}],
                  'evolves_to' =>
                   [{'id' => 3,
                     'name' => 'フシギバナ',
                     'is_baby' => false,
                     'evolution_details' =>
                      [{'item' => nil,
                        'trigger' => {'name' => 'level-up', 'url' => 'https://pokeapi.co/api/v2/evolution-trigger/1/'},
                        'gender' => nil,
                        'held_item' => nil,
                        'known_move' => nil,
                        'known_move_type' => nil,
                        'location' => nil,
                        'min_level' => 32,
                        'min_happiness' => nil,
                        'min_beauty' => nil,
                        'min_affection' => nil,
                        'needs_overworld_rain' => false,
                        'party_species' => nil,
                        'party_type' => nil,
                        'relative_physical_stats' => nil,
                        'time_of_day' => '',
                        'trade_species' => nil,
                        'turn_upside_down' => false}],
                     'evolves_to' => [],
                     'is_in_version_group' => true}],
                  'is_in_version_group' => true}],
              'is_in_version_group' => true
            }
          )
        end
    end

    context 'when pokemon id is one which is not default form' do
      let(:id){ 10033 } # メガフシギバナ
      let(:version_group){ 'lets-go-pikachu-lets-go-eevee' }

        it do
          get evolution_chain_api_pokemon_path(id), params: {version_group: version_group}
          expect(response).to have_http_status(:success)
          expect(response.parsed_body['evolution_chain']).to eq(
            {'id' => 1,
             'name' => 'フシギダネ',
             'is_baby' => false,
             'evolution_details' => [],
             'evolves_to' =>
             [{'id' => 2,
               'name' => 'フシギソウ',
               'is_baby' => false,
               'evolution_details' =>
                [{'item' => nil,
                  'trigger' => {'name' => 'level-up', 'url' => 'https://pokeapi.co/api/v2/evolution-trigger/1/'},
                  'gender' => nil,
                  'held_item' => nil,
                  'known_move' => nil,
                  'known_move_type' => nil,
                  'location' => nil,
                  'min_level' => 16,
                  'min_happiness' => nil,
                  'min_beauty' => nil,
                  'min_affection' => nil,
                  'needs_overworld_rain' => false,
                  'party_species' => nil,
                  'party_type' => nil,
                  'relative_physical_stats' => nil,
                  'time_of_day' => '',
                  'trade_species' => nil,
                  'turn_upside_down' => false}],
               'evolves_to' =>
                [{'id' => 3,
                  'name' => 'フシギバナ',
                  'is_baby' => false,
                  'evolution_details' =>
                   [{'item' => nil,
                     'trigger' => {'name' => 'level-up', 'url' => 'https://pokeapi.co/api/v2/evolution-trigger/1/'},
                     'gender' => nil,
                     'held_item' => nil,
                     'known_move' => nil,
                     'known_move_type' => nil,
                     'location' => nil,
                     'min_level' => 32,
                     'min_happiness' => nil,
                     'min_beauty' => nil,
                     'min_affection' => nil,
                     'needs_overworld_rain' => false,
                     'party_species' => nil,
                     'party_type' => nil,
                     'relative_physical_stats' => nil,
                     'time_of_day' => '',
                     'trade_species' => nil,
                     'turn_upside_down' => false}],
                  'evolves_to' => [],
                  'is_in_version_group' => true}],
               'is_in_version_group' => true}],
             'is_in_version_group' => true}
          )
        end
    end
  end
end
