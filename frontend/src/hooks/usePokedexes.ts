import { Pokedex, VERSION_GROUP } from "../types/api";

type PokeVersion = {
  name: string;
  pokedexes: string[];
  version_group: VERSION_GROUP;
};

const POKE_VERSION: PokeVersion[] = [
  {
    name: "ピカブイ",
    version_group: "lets-go-pikachu-lets-go-eevee",
    pokedexes: ["letsgo-kanto"],
  },
  {
    name: "ハートゴールド・ソウルシルバー",
    version_group: "heartgold-soulsilver",
    pokedexes: ["updated-johto"],
  },
  {
    name: "剣盾",
    version_group: "sword-shield",
    pokedexes: ["galar", "isle-of-armor", "crown-tundra"],
  },
  {
    name: "SV",
    version_group: "scarlet-violet",
    pokedexes: ["paldea", "kitakami", "blueberry"],
  },
];

const pokemonListMap = new Map<string, Pokedex[]>();

export function usePokedexes(params: {
  name: string;
  version_group: VERSION_GROUP;
  pokedexStrs: string[];
}) {
  const { name, version_group, pokedexStrs } = params;
  const searchParams = new URLSearchParams();
  pokedexStrs.forEach((pokedex) => searchParams.append(`pokedexes[]`, pokedex));

  const cachedPokemonList = pokemonListMap.get(version_group);
  if (cachedPokemonList) {
    const filteredPokedexes = cachedPokemonList.map((pokedex) => {
      return {
        name: pokedex.name,
        pokemons: pokedex.pokemons.filter((pokemon) =>
          pokemon.display_name.includes(name)
        ),
      };
    });
    return {
      pokedexes: cachedPokemonList,
      filteredPokedexes,
    };
  }

  throw fetch(`/api/pokemons?${searchParams}`)
    .then((res) => res.json() as Promise<Pokedex[]>)
    .then((pokedexes) => pokemonListMap.set(version_group, pokedexes));
}
