import { Container, DescriptionList } from "@freee_jp/vibes";
import "@freee_jp/vibes/css";
import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import "./App.css";

function Pokemon() {
  const { id } = useParams();
  const [pokemon, setPokemon] = useState<any>({});

  useEffect(() => {
    (async () => {
      const res = await fetch(`/api/pokemons/${id}`);
      setPokemon(await res.json());
    })();
  }, [id]);

  return (
    <>
      <Container width="wide" mb={1}>
        <img src={pokemon?.sprites?.front_default} />
      </Container>

      <DescriptionList
        listContents={[
          {
            title: "ID",
            value: pokemon.id,
          },
          {
            title: "名前",
            value: pokemon.name,
          },
          {
            title: "タイプ",
            value: pokemon?.types
              ?.map((type: { name: string }) => type.name)
              .join(", "),
          },
          {
            title: "HP",
            value: pokemon?.status?.hp.base_stat,
          },
          {
            title: "攻撃",
            value: pokemon?.status?.attack.base_stat,
          },
          {
            title: "防御",
            value: pokemon?.status?.defense.base_stat,
          },
          {
            title: "特攻",
            value: pokemon?.status?.special_attack.base_stat,
          },
          {
            title: "特防",
            value: pokemon?.status?.special_defense.base_stat,
          },
          {
            title: "スピード",
            value: pokemon?.status?.speed.base_stat,
          },
        ]}
      />
    </>
  );
}

export default Pokemon;
