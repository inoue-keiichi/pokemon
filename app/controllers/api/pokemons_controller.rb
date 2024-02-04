class Api::PokemonsController < ApplicationController
  def index
    @result = PokeApi.get(pokemon: {limit: 151, offset: 0})
    render json: {
      results: @result.results.map{ |r| {name: I18n.t('pokemon.' + r.name), url: r.url, id: r.url.sub("https://pokeapi.co/api/v2/pokemon/","").sub("/","").to_i}}
    }
  end

  def show
    @pokemon = PokeApi.get(pokemon: params[:id])
    @pokemon_species = PokeApi.get(pokemon_species: @pokemon.name)

    render json:{
      id: @pokemon.id,
      name: I18n.t('pokemon.' + @pokemon.name),
      types:  @pokemon.types.map { |type| {slot: type.slot, name: I18n.t('type.' + type.type.name), url: type.type.url}},
      status: @pokemon.stats.map { |stat| [stat.stat.name.sub("-","_"),{ base_stat: stat.base_stat, effort: stat.effort }] }.to_h,
      sprites: @pokemon.sprites,
      flavor_text: @pokemon_species.flavor_text_entries.select{ |entry| entry.language.name=="ja" && entry.version.name=="lets-go-pikachu" }.first&.flavor_text || @pokemon_species.flavor_text_entries.select{ |entry| entry.language.name=="ja" }.first
    }
  end
end
