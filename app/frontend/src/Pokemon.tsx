import {
  DescriptionList,
  HStack,
  ListTable,
  Loading,
  VStack,
} from "@freee_jp/vibes";
import "@freee_jp/vibes/css";
import { t } from "i18next";
import { Suspense } from "react";
import { ErrorBoundary } from "react-error-boundary";
import { useSelector } from "react-redux";
import { Link, useParams } from "react-router-dom";
import {
  PolarAngleAxis,
  PolarGrid,
  PolarRadiusAxis,
  Radar,
  RadarChart,
  Tooltip,
} from "recharts";
import "./App.css";
import { usePokemon } from "./hooks/usePokemon";
import { RootState } from "./store";
import { VERSION_GROUP } from "./types/api";

function Pokemon() {
  const { id } = useParams();
  const { version_group } = useSelector(
    (state: RootState) => state.searchFilter
  );

  return (
    <>
      <Link to="/pokemons">ポケモンリストへ戻る</Link>
      {/* TODO: Error メッセージ用意する */}
      <ErrorBoundary fallback={<div>Error</div>}>
        <Suspense fallback={<Loading coverAll isLoading />}>
          <FetchPokemon id={Number(id)} region={version_group} />
        </Suspense>
      </ErrorBoundary>
    </>
  );
}

function FetchPokemon(props: { id: number; region: VERSION_GROUP }) {
  const { id, region } = props;
  const pokemon = usePokemon(id, region);

  const damageFrom = (() => {
    const fourTimes: string[] = [];
    const doubles: string[] = [];
    const ones: string[] = [];
    const zeros: string[] = [];
    const halfs: string[] = [];
    const quarters: string[] = [];
    for (const key in pokemon.damage_from) {
      switch (pokemon.damage_from[key]) {
        case 4:
          fourTimes.push(t(`type.${key}`));
          break;
        case 2:
          doubles.push(t(`type.${key}`));
          break;
        case 1:
          ones.push(t(`type.${key}`));
          break;
        case 0:
          zeros.push(t(`type.${key}`));
          break;
        case 0.5:
          halfs.push(t(`type.${key}`));
          break;
        case 0.25:
          quarters.push(t(`type.${key}`));
          break;
        default:
          throw new Error("unkown multiple number");
      }
    }
    return [
      { cells: [{ value: "4" }, { value: fourTimes.join(", ") }] },
      { cells: [{ value: "2" }, { value: doubles.join(", ") }] },
      { cells: [{ value: "1" }, { value: ones.join(", ") }] },
      { cells: [{ value: "0.5" }, { value: halfs.join(", ") }] },
      { cells: [{ value: "0.25" }, { value: quarters.join(", ") }] },
      { cells: [{ value: "0" }, { value: zeros.join(", ") }] },
    ];
  })();

  const levelMoves = pokemon.moves
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

  const machineMoves = pokemon.moves
    .filter((move: any) => move.move_learn_method === "machine")
    .map((move: any) => ({
      cells: [
        {
          value: move.name,
        },
      ],
    }));

  const statuses = [
    {
      subject: "HP",
      status: pokemon.status.hp.base_stat,
    },
    {
      subject: "攻撃",
      status: pokemon.status.attack.base_stat,
    },
    {
      subject: "防御",
      status: pokemon.status.defense.base_stat,
    },
    {
      subject: "特攻",
      status: pokemon.status.special_attack.base_stat,
    },
    {
      subject: "特防",
      status: pokemon.status.special_defense.base_stat,
    },
    {
      subject: "スピード",
      status: pokemon.status.speed.base_stat,
    },
  ];

  return (
    <VStack alignItems={"center"}>
      <HStack>
        <img style={{ width: "200px" }} src={pokemon?.sprites?.front_default} />
        <RadarChart outerRadius={120} width={350} height={350} data={statuses}>
          <PolarGrid />
          <PolarAngleAxis dataKey="subject" />
          <PolarRadiusAxis angle={90} domain={[0, 160]} />
          <Radar
            name={pokemon.name}
            dataKey="status"
            dot
            stroke="#8884d8"
            fill="#8884d8"
            fillOpacity={0.6}
          ></Radar>
          <Tooltip />
        </RadarChart>
      </HStack>
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
              ?.map((type: { name: string }) => t(`type.${type.name}`))
              .join(", "),
          },
          {
            title: "説明",
            value: pokemon?.flavor_text,
          },
        ]}
      />
      <h2>受けるダメージ</h2>
      <ListTable
        headers={[
          {
            value: "倍率",
          },
          {
            value: "タイプ",
          },
        ]}
        rows={damageFrom}
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
  );
}

export default Pokemon;
