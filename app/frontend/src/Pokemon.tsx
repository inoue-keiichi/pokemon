import { Container, DescriptionList, ListTable } from "@freee_jp/vibes";
import "@freee_jp/vibes/css";
import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import "./App.css";

function Pokemon() {
  const { id } = useParams();
  const [pokemon, setPokemon] = useState<any>();

  useEffect(() => {
    (async () => {
      const res = await fetch(`/api/pokemons/${id}`);
      setPokemon(await res.json());
    })();
  }, [id]);

  if (!pokemon) {
    return <></>;
  }

  const levelMoves = pokemon?.moves
    .filter((move: any) => move.move_learn_method === "level-up")
    .map((move: any) => ({
      cells: [
        {
          value: move.name,
        },
        {
          value: move.level_learned_at,
        },
      ],
    }));

  const machineMoves = pokemon?.moves
    .filter((move: any) => move.move_learn_method === "machine")
    .map((move: any) => ({
      cells: [
        {
          value: move.name,
        },
      ],
    }));

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
          {
            title: "説明",
            value: pokemon?.flavor_text,
          },
        ]}
      />
      <h1>レベル技</h1>
      <ListTable
        headers={[
          {
            value: "名前",
          },
          {
            value: "レベル",
          },
        ]}
        rows={levelMoves}
      />
      <h1>わざマシン</h1>
      <ListTable
        headers={[
          {
            value: "名前",
          },
        ]}
        rows={machineMoves}
      />
    </>
  );
}

export default Pokemon;
