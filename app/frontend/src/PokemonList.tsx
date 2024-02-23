import {
  GridBlock,
  GridWrapper,
  HStack,
  ListCard,
  SelectBox,
} from "@freee_jp/vibes";
import "@freee_jp/vibes/css";
import { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import { useDispatch, useSelector } from "react-redux";
import { useNavigate } from "react-router-dom";
import "./App.css";
import { searchFilterUpdated } from "./features/searchFilterSlice";
import { RootState } from "./store";
import { IndexResponse, Pokemon, Region } from "./types/api";

type PokeCategory = {
  name: string;
  region: Region;
  pokedexes: string[];
};

const POKE_CATEGORY: PokeCategory[] = [
  { name: "ピカブイ", region: "kanto", pokedexes: ["letsgo-kanto"] },
  {
    name: "ハートゴールド・ソウルシルバー",
    region: "johto",
    pokedexes: ["updated-johto"],
  },
  {
    name: "剣盾",
    region: "galar",
    pokedexes: ["galar", "isle-of-armor", "crown-tundra"],
  },
  {
    name: "SV",
    region: "paldea",
    pokedexes: ["paldea", "kitakami", "blueberry"],
  },
];

function PokemonList() {
  const { region } = useSelector((state: RootState) => state.searchFilter);
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const { t } = useTranslation();

  const [pokemons, setPokemons] = useState<Pokemon[]>([]);

  useEffect(() => {
    (async () => {
      const res = await fetch(`/api/pokemons?region=${region}`);
      const json = (await res.json()) as IndexResponse;
      setPokemons(json.pokemons);
    })();
  }, [region]);

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

  const getPokedexNames = (region: Region) => {
    return POKE_CATEGORY.find((el) => el.region === region)!.pokedexes!;
  };

  const pokedexNames = getPokedexNames(region);
  const pokedexMap = groupByPokedex(pokemons, pokedexNames);

  return (
    <>
      <h1>ポケモンリスト</h1>
      <HStack mb={1} justifyContent={"center"}>
        <SelectBox
          mb={1}
          defaultValue={region}
          options={POKE_CATEGORY.map((poke) => {
            return { name: poke.name, value: poke.region };
          })}
          onChange={(e) => {
            dispatch(searchFilterUpdated({ region: e.target.value as Region }));
          }}
        />
      </HStack>

      {pokedexNames.map((pokedexName) => {
        return (
          <>
            <h2>{t(`pokedex.${pokedexName}`)}</h2>
            <GridWrapper>
              {pokedexMap.get(pokedexName)!.map((pokemon) => {
                return (
                  <GridBlock key={pokemon.id} size={"oneThird"} mb={1}>
                    <ListCard
                      title={pokemon.name}
                      onClick={() => navigate(`/pokemons/${pokemon.id}`)}
                    />
                  </GridBlock>
                );
              })}
            </GridWrapper>
          </>
        );
      })}
    </>
  );
}

export default PokemonList;
