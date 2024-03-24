module PokemonUtil
  def sub_id_from(url)
    if url.include?('https://pokeapi.co/api/v2/pokemon-species/')
      url.sub('https://pokeapi.co/api/v2/pokemon-species/', '').sub('/', '').to_i
    else
      url.sub('https://pokeapi.co/api/v2/pokemon/', '').sub('/', '').to_i
    end
  end
end
