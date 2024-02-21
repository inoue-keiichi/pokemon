import {
  GridBlock,
  GridWrapper,
  HStack,
  ListCard,
  SelectBox,
} from "@freee_jp/vibes";
import "@freee_jp/vibes/css";
import { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { useNavigate } from "react-router-dom";
import "./App.css";
import { searchFilterUpdated } from "./features/searchFilterSlice";
import { RootState } from "./store";

function PokemonList() {
  const { region } = useSelector((state: RootState) => state.searchFilter);
  const dispatch = useDispatch();
  const navigate = useNavigate();

  const [pokemons, setPokemons] = useState<any[]>([]);

  useEffect(() => {
    (async () => {
      const res = await fetch(`/api/pokemons?region=${region}`);
      setPokemons((await res.json()).pokemons);
    })();
  }, [region]);

  return (
    <>
      <h1>ポケモンリスト</h1>
      <HStack mb={1} justifyContent={"center"}>
        <SelectBox
          mb={1}
          defaultValue={region}
          options={[
            { name: "カントー", value: "kanto" },
            { name: "ジョート", value: "johto" },
            { name: "ガラル", value: "galar" },
            { name: "パルデア", value: "paldea" },
          ]}
          onChange={(e) => {
            dispatch(searchFilterUpdated({ region: e.target.value }));
          }}
        />
      </HStack>

      <GridWrapper>
        {pokemons?.map((pokemon) => (
          <GridBlock key={pokemon.id} size={"oneThird"} mb={1}>
            <ListCard
              title={pokemon.name}
              onClick={() => navigate(`/pokemons/${pokemon.id}`)}
            />
          </GridBlock>
        ))}
      </GridWrapper>
    </>
  );
}

export default PokemonList;
