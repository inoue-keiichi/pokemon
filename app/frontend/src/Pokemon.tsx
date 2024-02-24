import { DescriptionList, ListTable, VStack } from "@freee_jp/vibes";
import "@freee_jp/vibes/css";
import { useEffect, useState } from "react";
import { useSelector } from "react-redux";
import { Link, useParams } from "react-router-dom";
import "./App.css";
import { RootState } from "./store";

function Pokemon() {
  const { id } = useParams();
  const [pokemon, setPokemon] = useState<any>();
  const { region } = useSelector((state: RootState) => state.searchFilter);

  useEffect(() => {
    (async () => {
      const res = await fetch(`/api/pokemons/${id}?region=${region}`);
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
      <Link to="/pokemons">ポケモンリストへ戻る</Link>
      <VStack alignItems={"center"}>
        <img src={pokemon?.sprites?.front_default} />

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
        <h2>レベル技</h2>
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
        <h2>わざマシン</h2>
        <ListTable
          headers={[
            {
              value: "名前",
            },
          ]}
          rows={machineMoves}
        />
      </VStack>
    </>
  );
}

export default Pokemon;
