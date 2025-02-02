export type IndexResponse = {
  pokedexes: string[];
  pokemons: Pokemon[];
  version_groups: string[];
};

export type Pokedex = {
  name: string;
  pokemons: {
    id: number;
    pokedex_number: number;
    name: string;
    display_name: string;
  }[];
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
  species_id: number;
  name: string;
  types: { name: string; slot: number }[];
  status: {
    name: string;
    label: string;
    base_stat: number;
    effort: number;
  }[];
  sprites: {
    front_default: string;
  };
  abilities: {
    name: string;
    is_hidden: string;
    flavor_text?: string;
  }[];
  flavor_text?: string;
  moves: {
    level_learned_at: number;
    move_learn_method: string;
    name: string;
  }[];
  version_group: VERSION_GROUP;
  damage_from: any;
  evolution_chain: Evolution;
  form_type: {
    name: string;
    type: string;
  };
};

export type FormsResponse = {
  forms: {
    id: number;
    name: string;
    is_in_version_group: boolean;
    is_default: boolean;
  }[];
};

export type EvolutionChainResponse = {
  evolution_chain: Evolution;
};

export type Evolution = {
  id: number;
  name: string;
  is_baby: boolean;
  evolution_details: EvolutionDetail[];
  next_ids: number[];
  evolves_to: Evolution[];
  is_in_version_group: boolean;
};

export type EvolutionDetail = {
  min_level?: number;
};

type Status = {
  base_stat: number;
  effort: number;
};
