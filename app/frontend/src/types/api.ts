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

export type ShowResponse = {
  id: number;
  name: string;
  types: any[];
  status: {
    attack: Status;
    defense: Status;
    hp: Status;
    special_attack: Status;
    special_defense: Status;
    speed: Status;
  };
  sprites: {
    front_default: string;
  };
  flavor_text: string;
  moves: {
    level_learned_at: number;
    move_learn_method: string;
    name: string;
  }[];
  version_group: VERSION_GROUP;
  damage_from: any;
  evolution_chain: Evolution;
};

export type FormsResponse = {
  forms: { id: number; name: string; is_in_version_group: boolean }[];
};

export type Evolution = {
  id: number;
  name: string;
  is_baby: boolean;
  evolution_details: any[];
  next_ids: number[];
  evolves_to: Evolution[];
  is_in_version_group: boolean;
};

type Status = {
  base_stat: number;
  effort: number;
};
