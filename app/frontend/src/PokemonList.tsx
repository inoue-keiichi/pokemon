import { ListTable } from "@freee_jp/vibes";
import "@freee_jp/vibes/css";
import { useEffect, useState } from "react";
import "./App.css";

function PokemonList() {
  const [pokemons, setPokemons] = useState<any[]>([]);

  useEffect(() => {
    (async () => {
      console.log(import.meta.env.BASE_URL);
      const res = await fetch(`/api/pokemons`);
      setPokemons((await res.json()).results);
    })();
  }, []);

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
