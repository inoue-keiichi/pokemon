# frozen_string_literal: true

class Api::PokemonsController < ApplicationController
  def index
    pokemon_list = PokemonList.new(region: params[:region])
    render json: Pokemon::Index::Serializer.new.serialize(pokemon_list).to_json
  end

  def show
    # TODO: client から version を渡すようにする。たぶんゲーム単位でみたいはずなので。
    excluded_vg_list = ['the-isle-of-armor', 'the-crown-tundra', 'the-teal-mask', 'the-indigo-disk']
    version_group = PokeApi.get(region: params[:region]).version_groups.reject{ |vg| excluded_vg_list.include?(vg.name) }.last.name # 最後の要素が最新のバージョンのはず
    pokemon_profile = PokemonProfile.new(id: params[:id].to_i, version_group: version_group)
    render json: Pokemon::Show::Serializer.new.serialize(pokemon_profile).to_json
  end
end
