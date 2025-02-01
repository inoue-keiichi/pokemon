import {
  ColumnBase,
  FormControl,
  GridBlock,
  GridWrapper,
  HStack,
  InlineSpinner,
  ListCard,
  Loading,
  SelectBox,
  SingleComboBox,
  SingleComboBoxOption,
} from "@freee_jp/vibes";
import "@freee_jp/vibes/css";
import Romanizer from "js-hira-kata-romanize";
import { Dispatch, SetStateAction, Suspense, useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import { useDispatch, useSelector } from "react-redux";
import { useNavigate } from "react-router-dom";
import { searchFilterUpdated } from "./features/searchFilterSlice";
import { usePokedexes } from "./hooks/usePokedexes";
import { RootState } from "./store";
import { Pokedex, VERSION_GROUP } from "./types/api";
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
  const [pokedexes, setPokedexes] = useState<Pokedex[]>([]);

  const createKeywords = (name: string) => {
    return [
      kanaToHira(name),
      romanizer.romanize(name),
      romanizer.romanize(name).toLowerCase(),
    ];
  };

  const nameComboboxValue =
    state.name === ""
      ? undefined
      : {
          id: state.id,
          label: state.name,
          keywords: createKeywords(state.name),
        };

  const nameComboboxOptions = (() => {
    const tmp = new Map<number, { label: string; keywords: string[] }>();
    pokedexes.forEach((pokedex) => {
      pokedex.pokemons.forEach((pokemon) => {
        tmp.set(pokemon.id, {
          label: pokemon.display_name,
          keywords: createKeywords(pokemon.display_name),
        });
      });
    });

    const options: SingleComboBoxOption[] = [
      {
        id: -1,
        label: "",
        subLabel: "クリア",
        keywords: [],
      },
    ];
    for (const [id, { label, keywords }] of tmp.entries()) {
      options.push({ id, label, keywords });
    }
    return options;
  })();

  return (
    <>
      <ColumnBase>
        <HStack justifyContent={"center"}>
          <div style={{ textAlign: "left" }}>
            <FormControl label="バージョン" fieldId="versionSelectBox">
              <SelectBox
                id="versionSelectBox"
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
            </FormControl>
          </div>
          <div style={{ textAlign: "left" }}>
            <FormControl label="名前" fieldId="nameCombobox">
              <SingleComboBox
                id="nameCombobox"
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
              />
            </FormControl>
          </div>
        </HStack>
      </ColumnBase>
      <Suspense
        fallback={
          <Loading isLoading>
            <InlineSpinner isLoading large />
          </Loading>
        }
      >
        <FetchPokemonList state={state} setPokedexes={setPokedexes} />
      </Suspense>
    </>
  );
}

type PokeListProps = {
  state: {
    id: number;
    name: string;
    version_group: VERSION_GROUP;
  };
  setPokedexes: Dispatch<SetStateAction<Pokedex[]>>;
};

const FetchPokemonList = (props: PokeListProps) => {
  const { state, setPokedexes } = props;

  const { t } = useTranslation();
  const navigate = useNavigate();

  const pokedexStrs = POKE_VERSION.find(
    (pokeVersion) => pokeVersion.version_group === state.version_group
  )?.pokedexes!;
  const { id, ...others } = state;
  const { pokedexes, filteredPokedexes } = usePokedexes({
    ...others,
    pokedexStrs,
  });

  useEffect(() => setPokedexes(pokedexes), [state]);

  return (
    <div>
      {filteredPokedexes.map((pokedex) => (
        <div key={`pokedex_${pokedex.name}`}>
          <h2>{t(`pokedex.${pokedex.name}`)}</h2>
          <GridWrapper>
            {pokedex.pokemons.map((pokemon) => (
              <GridBlock
                key={`pokemon_${pokemon.id}_${pokemon.pokedex_number}`}
                size={"oneThird"}
                mb={1}
              >
                <ListCard
                  title={`${pokemon.pokedex_number}. ${pokemon.display_name}`}
                  onClick={() => navigate(`/pokemons/${pokemon.id}`)}
                />
              </GridBlock>
            ))}
          </GridWrapper>
        </div>
      ))}
    </div>
  );
};

export default PokemonList;
