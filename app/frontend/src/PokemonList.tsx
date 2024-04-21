import {
  ColumnBase,
  GridBlock,
  GridWrapper,
  HStack,
  ListCard,
  SelectBox,
  SingleComboBox,
  SingleComboBoxOption,
} from "@freee_jp/vibes";
import "@freee_jp/vibes/css";
import Romanizer from "js-hira-kata-romanize";
import { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import { useDispatch, useSelector } from "react-redux";
import { useNavigate } from "react-router-dom";
import "./App.css";
import { searchFilterUpdated } from "./features/searchFilterSlice";
import { RootState } from "./store";
import { IndexResponse, Pokemon, VERSION_GROUP } from "./types/api";
import { kanaToHira } from "./utils";

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

const romanizer = new Romanizer({
  chouon: Romanizer.CHOUON_SKIP,
});

function PokemonList() {
  const state = useSelector((state: RootState) => state.searchFilter);
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const { t } = useTranslation();

  const [pokemons, setPokemons] = useState<Pokemon[]>([]);

  useEffect(() => {
    (async () => {
      const res = await fetch(
        `/api/pokemons?version_group=${state.version_group}`
      );
      const json = (await res.json()) as IndexResponse;
      setPokemons(json.pokemons);
    })();
  }, [state.version_group]);

  const groupByPokedex = (pokemons: Pokemon[], pokedexNames: string[]) => {
    const flattenPokes = pokemons.flatMap((pokemon) => {
      const { pokedexes, ...other } = pokemon;
      return pokedexes.map((pokedex) => ({
        ...other,
        pokedex,
      }));
    });

    const result = new Map<
      string,
      { id: number; name: string; entry_number: number }[]
    >();
    pokedexNames.forEach((name) => result.set(name, []));

    flattenPokes.forEach((poke) => {
      const {
        pokedex: { name, entry_number },
        region,
        ...other
      } = poke;
      result.get(name)?.push({ ...other, entry_number: entry_number });
    });

    result.forEach((value) => {
      value.sort((a, b) => a.entry_number - b.entry_number);
    });

    return result;
  };

  const getPokedexNames = (version_group: VERSION_GROUP) => {
    return POKE_VERSION.find((el) => el.version_group === version_group)!
      .pokedexes!;
  };

  const createKeywords = (name: string) => {
    return [
      kanaToHira(name),
      romanizer.romanize(name),
      romanizer.romanize(name).toLowerCase(),
    ];
  };

  const pokedexNames = getPokedexNames(state.version_group);
  const filterdPokemons = pokemons.filter(
    (pokemon) => pokemon.name.indexOf(state.name) !== -1
  );
  const pokedexMap = groupByPokedex(filterdPokemons, pokedexNames);

  const nameComboboxValue =
    state.name === ""
      ? undefined
      : {
          id: state.id,
          label: state.name,
          keywords: createKeywords(state.name),
        };

  const nameComboboxOptions = (() => {
    const options: SingleComboBoxOption[] = [
      {
        id: -1,
        label: "",
        subLabel: "クリア",
        keywords: [],
      },
    ];
    pokemons.forEach((pokemon) => {
      options.push({
        id: pokemon.id,
        label: pokemon.name,
        keywords: createKeywords(pokemon.name),
      });
    });
    return options;
  })();

  return (
    <>
      <ColumnBase>
        <HStack justifyContent={"center"}>
          <SelectBox
            id="filterRegion"
            defaultValue={state.version_group}
            options={POKE_VERSION.map((poke) => {
              return { name: poke.name, value: poke.version_group };
            })}
            onChange={(e) => {
              dispatch(
                searchFilterUpdated({
                  ...state,
                  version_group: e.target.value as VERSION_GROUP,
                })
              );
            }}
          />
          <SingleComboBox
            value={nameComboboxValue}
            options={nameComboboxOptions}
            onChange={(e) => {
              if (!e) {
                return;
              }
              dispatch(
                searchFilterUpdated({
                  ...state,
                  id: Number(e.id),
                  name: e.label,
                })
              );
            }}
          ></SingleComboBox>
        </HStack>
      </ColumnBase>

      {pokedexNames.map((pokedexName) => {
        const target = pokedexMap.get(pokedexName);
        if (!target || target.length == 0) {
          return;
        }
        return (
          <div key={`pokedex_${pokedexName}`}>
            <h2>{t(`pokedex.${pokedexName}`)}</h2>
            <GridWrapper>
              {target.map((pokemon) => {
                return (
                  <GridBlock
                    key={`pokemon_${pokemon.id}_${pokemon.entry_number}`}
                    size={"oneThird"}
                    mb={1}
                  >
                    <ListCard
                      title={`${pokemon.entry_number}. ${pokemon.name}`}
                      onClick={() => navigate(`/pokemons/${pokemon.id}`)}
                    />
                  </GridBlock>
                );
              })}
            </GridWrapper>
          </div>
        );
      })}
    </>
  );
}

export default PokemonList;
