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

export type VERSION_GROUP =
  | "lets-go-pikachu-lets-go-eevee"
  | "heartgold-soulsilver"
  | "sword-shield"
  | "scarlet-violet";
