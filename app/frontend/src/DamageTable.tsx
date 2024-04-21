import { GridBlock, NumericTable, NumericTableHeader } from "@freee_jp/vibes";

const createTypeDamageMap = () => {
  return new Map([
    ["normal", { value: "", order: 0 }],
    ["fire", { value: "", order: 1 }],
    ["water", { value: "", order: 2 }],
    ["electric", { value: "", order: 3 }],
    ["grass", { value: "", order: 4 }],
    ["ice", { value: "", order: 5 }],
    ["fighting", { value: "", order: 6 }],
    ["poison", { value: "", order: 7 }],
    ["ground", { value: "", order: 8 }],
    ["flying", { value: "", order: 9 }],
    ["psychic", { value: "", order: 10 }],
    ["bug", { value: "", order: 11 }],
    ["rock", { value: "", order: 12 }],
    ["ghost", { value: "", order: 13 }],
    ["dragon", { value: "", order: 14 }],
    ["dark", { value: "", order: 15 }],
    ["steel", { value: "", order: 16 }],
    ["fairy", { value: "", order: 17 }],
  ]);
};

type Damage = {
  double_from: string[];
  double_to: string[];
  half_from: string[];
  half_to: string[];
  no_from: string[];
  no_to: string[];
};

const aggregateDamageTo = (damage: Damage) => {
  const result = createTypeDamageMap();
  for (const type of damage.double_to) {
    const damage = result.get(type);
    if (damage) {
      damage.value = "⚪︎";
    }
  }
  for (const type of damage.half_to) {
    const damage = result.get(type);
    if (damage) {
      damage.value = "△";
    }
  }
  for (const type of damage.no_to) {
    const damage = result.get(type);
    if (damage) {
      damage.value = "×";
    }
  }

  const damages = [...result.values()];
  return damages
    .sort((a, b) => a.order - b.order)
    .map((damage) => ({
      value: damage.value,
    }));
};

const createRows = () => {
  return Object.values(TYPE_MAP)
    .sort((a, b) => a.order - b.order)
    .map((type) => {
      const cells = [];
      cells.push({ value: type.name });
      cells.push(...aggregateDamageTo(type.damage));
      return { cells };
    });
};

export function DamageTable() {
  const headers: NumericTableHeader[] = TYPE_HEADERS.sort(
    (a, b) => a.order - b.order
  ).map((type) => ({
    value: type.name,
  }));
  headers.unshift({ value: "" });

  const rows = createRows();
  return (
    <>
      <h2>与えられるダメージ</h2>
      <GridBlock size={"half"}>
        <div
          style={{
            writingMode: "vertical-rl",
            textAlign: "center",
            display: "inline-block",
          }}
        >
          <h2>与えるダメージ</h2>
        </div>
        <div style={{ display: "inline-block" }}>
          <NumericTable rowHeaderCount={1} headers={headers} rows={rows} />
        </div>
      </GridBlock>
    </>
  );
}

const TYPE_HEADERS = [
  { name: "ノーマル", order: 0 },
  { name: "ほのお", order: 1 },
  { name: "みず", order: 2 },
  { name: "でんき", order: 3 },
  { name: "くさ", order: 4 },
  { name: "こおり", order: 5 },
  { name: "かくとう", order: 6 },
  { name: "どく", order: 7 },
  { name: "じめん", order: 8 },
  { name: "ひこう", order: 9 },
  { name: "エスパー", order: 10 },
  { name: "むし", order: 11 },
  { name: "いわ", order: 12 },
  { name: "ゴースト", order: 13 },
  { name: "ドラゴン", order: 14 },
  { name: "あく", order: 15 },
  { name: "はがね", order: 16 },
  { name: "フェアリー", order: 17 },
];

const TYPE_MAP = {
  normal: {
    name: "ノーマル",
    damage: {
      double_from: ["fighting"],
      double_to: [],
      half_from: [],
      half_to: ["rock", "steel"],
      no_from: ["ghost"],
      no_to: ["ghost"],
    },
    order: 0,
  },
  fighting: {
    name: "かくとう",
    damage: {
      double_from: ["flying", "psychic", "fairy"],
      double_to: ["normal", "rock", "steel", "ice", "dark"],
      half_from: ["rock", "bug", "dark"],
      half_to: ["flying", "poison", "bug", "psychic", "fairy"],
      no_from: [],
      no_to: ["ghost"],
    },
    order: 6,
  },
  flying: {
    name: "ひこう",
    damage: {
      double_from: ["rock", "electric", "ice"],
      double_to: ["fighting", "bug", "grass"],
      half_from: ["fighting", "bug", "grass"],
      half_to: ["rock", "steel", "electric"],
      no_from: ["ground"],
      no_to: [],
    },
    order: 9,
  },
  poison: {
    name: "どく",
    damage: {
      double_from: ["ground", "psychic"],
      double_to: ["grass", "fairy"],
      half_from: ["fighting", "poison", "bug", "grass", "fairy"],
      half_to: ["poison", "ground", "rock", "ghost"],
      no_from: [],
      no_to: ["steel"],
    },
    order: 7,
  },
  ground: {
    name: "じめん",
    damage: {
      double_from: ["water", "grass", "ice"],
      double_to: ["poison", "rock", "steel", "fire", "electric"],
      half_from: ["poison", "rock"],
      half_to: ["bug", "grass"],
      no_from: ["electric"],
      no_to: ["flying"],
    },
    order: 8,
  },
  rock: {
    name: "いわ",
    damage: {
      double_from: ["fighting", "ground", "steel", "water", "grass"],
      double_to: ["flying", "bug", "fire", "ice"],
      half_from: ["normal", "flying", "poison", "fire"],
      half_to: ["fighting", "ground", "steel"],
      no_from: [],
      no_to: [],
    },
    order: 12,
  },
  bug: {
    name: "むし",
    damage: {
      double_from: ["flying", "rock", "fire"],
      double_to: ["grass", "psychic", "dark"],
      half_from: ["fighting", "ground", "grass"],
      half_to: [
        "fighting",
        "flying",
        "poison",
        "ghost",
        "steel",
        "fire",
        "fairy",
      ],
      no_from: [],
      no_to: [],
    },
    order: 11,
  },
  ghost: {
    name: "ゴースト",
    damage: {
      double_from: ["ghost", "dark"],
      double_to: ["ghost", "psychic"],
      half_from: ["poison", "bug"],
      half_to: ["dark"],
      no_from: ["normal", "fighting"],
      no_to: ["normal"],
    },
    order: 13,
  },
  steel: {
    name: "はがね",
    damage: {
      double_from: ["fighting", "ground", "fire"],
      double_to: ["rock", "ice", "fairy"],
      half_from: [
        "normal",
        "flying",
        "rock",
        "bug",
        "steel",
        "grass",
        "psychic",
        "ice",
        "dragon",
        "fairy",
      ],
      half_to: ["steel", "fire", "water", "electric"],
      no_from: ["poison"],
      no_to: [],
    },
    order: 16,
  },
  fire: {
    name: "ほのお",
    damage: {
      double_from: ["ground", "rock", "water"],
      double_to: ["bug", "steel", "grass", "ice"],
      half_from: ["bug", "steel", "fire", "grass", "ice", "fairy"],
      half_to: ["rock", "fire", "water", "dragon"],
      no_from: [],
      no_to: [],
    },
    order: 1,
  },
  water: {
    name: "みず",
    damage: {
      double_from: ["grass", "electric"],
      double_to: ["ground", "rock", "fire"],
      half_from: ["steel", "fire", "water", "ice"],
      half_to: ["water", "grass", "dragon"],
      no_from: [],
      no_to: [],
    },
    order: 2,
  },
  grass: {
    name: "くさ",
    damage: {
      double_from: ["flying", "poison", "bug", "fire", "ice"],
      double_to: ["ground", "rock", "water"],
      half_from: ["ground", "water", "grass", "electric"],
      half_to: ["flying", "poison", "bug", "steel", "fire", "grass", "dragon"],
      no_from: [],
      no_to: [],
    },
    order: 4,
  },
  electric: {
    name: "でんき",
    damage: {
      double_from: ["ground"],
      double_to: ["flying", "water"],
      half_from: ["flying", "steel", "electric"],
      half_to: ["grass", "electric", "dragon"],
      no_from: [],
      no_to: ["ground"],
    },
    order: 3,
  },
  psychic: {
    name: "エスパー",
    damage: {
      double_from: ["bug", "ghost", "dark"],
      double_to: ["fighting", "poison"],
      half_from: ["fighting", "psychic"],
      half_to: ["steel", "psychic"],
      no_from: [],
      no_to: ["dark"],
    },
    order: 10,
  },
  ice: {
    name: "こおり",
    damage: {
      double_from: ["fighting", "rock", "steel", "fire"],
      double_to: ["flying", "ground", "grass", "dragon"],
      half_from: ["ice"],
      half_to: ["steel", "fire", "water", "ice"],
      no_from: [],
      no_to: [],
    },
    order: 5,
  },
  dragon: {
    name: "ドラゴン",
    damage: {
      double_from: ["ice", "dragon", "fairy"],
      double_to: ["dragon"],
      half_from: ["fire", "water", "grass", "electric"],
      half_to: ["steel"],
      no_from: [],
      no_to: ["fairy"],
    },
    order: 14,
  },
  dark: {
    name: "あく",
    damage: {
      double_from: ["fighting", "bug", "fairy"],
      double_to: ["ghost", "psychic"],
      half_from: ["ghost", "dark"],
      half_to: ["fighting", "dark", "fairy"],
      no_from: ["psychic"],
      no_to: [],
    },
    order: 15,
  },
  fairy: {
    name: "フェアリー",
    damage: {
      double_from: ["poison", "steel"],
      double_to: ["fighting", "dragon", "dark"],
      half_from: ["fighting", "bug", "dark"],
      half_to: ["poison", "steel", "fire"],
      no_from: ["dragon"],
      no_to: [],
    },
    order: 17,
  },
};

export default DamageTable;
