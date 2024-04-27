import { ShowResponse } from "../types/api";

const pokemonMap = new Map<string, ShowResponse>();

export function usePokemon(id: number, version_group: string) {
  const key = `${id}_${version_group}`;

  const cachedPokemon = pokemonMap.get(key);

  if (cachedPokemon) {
    return cachedPokemon;
  }

  throw fetch(`/api/pokemons/${id}?version_group=${version_group}`)
    .then((res) => {
      return res.json();
    })
    .then((json) => {
      pokemonMap.set(key, json);
    });
}
