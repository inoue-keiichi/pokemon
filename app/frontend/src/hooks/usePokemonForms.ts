import { FormsResponse } from "../types/api";

const pokemonFormMap = new Map<string, FormsResponse>();

export function usePokemonForms(id: number, version_group: string) {
  const key = `${id}_${version_group}`;

  const cachedPokemonForm = pokemonFormMap.get(key);

  if (cachedPokemonForm) {
    return cachedPokemonForm;
  }

  throw fetch(`/api/pokemons/${id}/forms?version_group=${version_group}`)
    .then((res) => {
      return res.json();
    })
    .then((json) => {
      pokemonFormMap.set(key, json);
    });
}
