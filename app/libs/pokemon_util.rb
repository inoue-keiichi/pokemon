module PokemonUtil
  def sub_id_from(url)
    url.sub('https://pokeapi.co/api/v2/pokemon-species/', '').sub('/', '').to_i
  end
end
