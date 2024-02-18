import { ListTable } from "@freee_jp/vibes";
import "@freee_jp/vibes/css";
import { useEffect, useState } from "react";
import "./App.css";

function PokemonList() {
  const [pokemons, setPokemons] = useState<any[]>([]);
  // TODO: セレクトボックスによる切り替えを実装する
  const [region, setRegion] = useState<string>("kanto");

  useEffect(() => {
    (async () => {
      console.log(import.meta.env.BASE_URL);
      const res = await fetch(`/api/pokemons?region=${region}`);
      setPokemons((await res.json()).pokemons);
    })();
  }, [region]);

  const rows = pokemons?.map((pokemon) => {
    return {
      url: `/pokemons/${pokemon.id}`,
      cells: [
        {
          value: pokemon.id,
        },
        {
          value: pokemon.name,
        },
      ],
    };
  });

  return (
    <>
      {/* <SelectBox
        options={[
          { name: "カントー", value: "kanto" },
          { name: "ジョート", value: "johto" },
        ]}
        onChange={(e) => {
          setRegion(e.target.value);
        }}
      /> */}
      <ListTable
        headers={[
          {
            value: "ID",
          },
          {
            value: "名前",
          },
        ]}
        rows={rows}
      />
    </>
  );
}

export default PokemonList;
