import {
  DescriptionList,
  HStack,
  ListTable,
  Loading,
  StatusIcon,
  Text,
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
import { useEvolutionChain } from "./hooks/useEvolutionChain";
import { usePokemon } from "./hooks/usePokemon";
import { usePokemonForms } from "./hooks/usePokemonForms";
import { RootState } from "./store";
import { Evolution, VERSION_GROUP } from "./types/api";

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
  //const [speciesId, setSpeciesId] = useState<number>(pokemon.spicies_id);
  const pokemon = usePokemon(id, region);
  console.log(`species_id: ${pokemon.species_id}`);

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
          value: move.level,
        },
        {
          value: move.type,
        },
        {
          value: move.power || "-",
        },
        {
          value: move.accuracy || "-",
        },
        {
          value: move.pp,
        },
        {
          value: move.flavor_text,
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
        {
          value: move.type,
        },
        {
          value: move.power || "-",
        },
        {
          value: move.accuracy || "-",
        },
        {
          value: move.pp,
        },
        {
          value: move.flavor_text,
        },
      ],
    }));

  const statuses = pokemon.status.map((s) => ({
    subject: s.label,
    status: s.base_stat,
  }));

  const listContents: {
    title: string;
    value: JSX.Element | string | number;
  }[] = (() => {
    const result: {
      title: string;
      value: JSX.Element | string | number;
    }[] = [
      {
        title: "ID",
        value: pokemon.id,
      },
      {
        title: "名前",
        value: pokemon.name,
      },
    ];

    if (pokemon?.form_type) {
      result.push({
        title: "すがた",
        value: pokemon.form_type.name,
      });
    }

    const type = {
      title: "タイプ",
      value: (
        <>
          {pokemon?.types?.map((type) => (
            <StatusIcon type="done" mr={0.5}>
              {type.name}
            </StatusIcon>
          ))}
        </>
      ),
    };
    result.push(type);

    const abilities = pokemon?.abilities?.map((ability, index) => ({
      title: `特性${index + 1}`,
      value: (
        <>
          <Text>{`${ability.name}`}</Text>
          {ability.is_hidden && (
            <StatusIcon type="done" ml={0.5}>
              夢特性
            </StatusIcon>
          )}
          {ability.flavor_text && (
            <>
              <br />
              <Text size={0.75}>{ability.flavor_text}</Text>
            </>
          )}
        </>
      ),
    }));
    result.push(...abilities);

    if (pokemon?.flavor_text) {
      result.push({
        title: "説明",
        value: pokemon?.flavor_text,
      });
    }

    return result;
  })();

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
      <DescriptionList listContents={listContents} />
      <h2>進化</h2>
      <Suspense
        fallback={
          <Loading isLoading={true}>
            <p>ロード中...</p>
          </Loading>
        }
      >
        <FetchEvolutionChain id={id} region={region} />
      </Suspense>
      <h2>すがた</h2>
      <Suspense
        fallback={
          <Loading isLoading={true}>
            <p>ロード中...</p>
          </Loading>
        }
      >
        <FetchPokemonForm
          species_id={pokemon.species_id}
          region={region}
        ></FetchPokemonForm>
      </Suspense>
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
            noWrap: true,
            minWidth: 10,
            value: "名前",
          },
          {
            noWrap: true,
            minWidth: 3,
            value: "レベル",
          },
          {
            noWrap: true,
            minWidth: 5,
            value: "タイプ",
          },
          {
            noWrap: true,
            minWidth: 3,
            value: "パワー",
          },
          {
            noWrap: true,
            minWidth: 3,
            value: "命中",
          },
          {
            noWrap: true,
            minWidth: 3,
            value: "PP",
          },
          {
            value: "説明",
          },
        ]}
        rows={levelMoves}
        fitContent={true}
      />
      <h2>わざマシン</h2>
      <ListTable
        headers={[
          {
            noWrap: true,
            minWidth: 10,
            value: "名前",
          },
          {
            noWrap: true,
            minWidth: 5,
            value: "タイプ",
          },
          {
            noWrap: true,
            minWidth: 3,
            value: "パワー",
          },
          {
            noWrap: true,
            minWidth: 3,
            value: "命中",
          },
          {
            noWrap: true,
            minWidth: 3,
            value: "PP",
          },
          {
            value: "説明",
          },
        ]}
        rows={machineMoves}
      />
    </VStack>
  );
}

function FetchPokemonForm(props: {
  species_id: number;
  region: VERSION_GROUP;
}) {
  const { species_id, region } = props;
  const { forms } = usePokemonForms(species_id, region);

  return (
    <HStack>
      {forms
        .filter((form) => !form.is_default)
        .map((form) => (
          <Link to={`/pokemons/${form.id}`}>
            {form.name.replace(/^.+\(/, "").replace(/\)$/, "")}
          </Link>
        ))}
    </HStack>
  );
}

function FetchEvolutionChain(props: { id: number; region: VERSION_GROUP }) {
  const { id, region } = props;
  const { evolution_chain: evolution } = useEvolutionChain(id, region);

  const evolution_layers = [[evolution]];
  const queue = [[evolution]];

  while (queue.length > 0) {
    const evolutions = queue.pop() as Evolution[];

    const evolution_layer: Evolution[] = [];
    for (const ev of evolutions) {
      evolution_layer.push(...ev.evolves_to);
    }
    if (evolution_layer.length > 0) {
      evolution_layers.push(evolution_layer);
      queue.push(evolution_layer);
    }
  }

  return (
    <HStack>
      {evolution_layers.map((layer) => (
        <VStack>
          {layer
            .filter((evolution) => evolution.is_in_version_group)
            .map((evolution) => (
              <Link to={`/pokemons/${evolution.id}`}>{evolution.name}</Link>
            ))}
        </VStack>
      ))}
    </HStack>
  );
}

export default Pokemon;
