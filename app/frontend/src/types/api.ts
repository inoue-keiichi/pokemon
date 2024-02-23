export type IndexResponse = {
  pokedexes: string[];
  pokemons: Pokemon[];
  version_groups: string[];
};

export type Pokemon = {
  id: number;
  name: string;
  region: string;
  pokedexes: { name: string; entry_number: number }[];
};

export type Region = "kanto" | "johto" | "galar" | "paldea";
