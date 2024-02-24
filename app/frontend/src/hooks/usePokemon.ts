const pokemonMap = new Map<string, any>();

export function usePokemon(id: number, region: string) {
  const key = `${id}_${region}`;

  const cachedPokemon = pokemonMap.get(key);

  if (cachedPokemon) {
    return cachedPokemon;
  }

  throw fetch(`/api/pokemons/${id}?region=${region}`)
    .then((res) => {
      return res.json();
    })
    .then((json) => {
      pokemonMap.set(key, json);
    });
}
