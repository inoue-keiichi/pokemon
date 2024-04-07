import { EvolutionChainResponse } from "../types/api";

const evolutionChainMap = new Map<string, EvolutionChainResponse>();

export function useEvolutionChain(id: number, version_group: string) {
  const key = `${id}_${version_group}`;

  const cachedEvolutionChain = evolutionChainMap.get(key);

  if (cachedEvolutionChain) {
    return cachedEvolutionChain;
  }

  throw fetch(
    `/api/pokemons/${id}/evolution_chain?version_group=${version_group}`
  )
    .then((res) => {
      return res.json();
    })
    .then((json) => {
      evolutionChainMap.set(key, json);
    });
}
