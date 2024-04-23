import {
  ColumnBase,
  FormControl,
  HStack,
  MultiComboBox,
  MultiComboBoxOption,
  NumericTable,
  ScrollableBase,
  Text,
} from "@freee_jp/vibes";
import { useState } from "react";

type DamageType = {
  id: number;
  label: string;
  value: string;
  damage: Damage;
};

const createTypeToDamageValue = (damageTypes: DamageType[]) => {
  return new Map(
    damageTypes.map((type) => [type.value, { value: "", order: type.id }])
  );
};

type Damage = {
  double_from: string[];
  double_to: string[];
  half_from: string[];
  half_to: string[];
  no_from: string[];
  no_to: string[];
};

export function DamageTable() {
  const [damageToTypes, setDamageToTypes] = useState<MultiComboBoxOption[]>([]);
  const [damageFromTypes, setDamageFromTypes] = useState<MultiComboBoxOption[]>(
    []
  );

  const options = DAMAGE_TYPES.map((type) => ({
    ...type,
    keywords: [type.label],
  }));

  const damageToTypeLabels = damageToTypes.map((type) => type.label);
  const damageTos =
    damageToTypeLabels.length === 0
      ? DAMAGE_TYPES
      : DAMAGE_TYPES.filter((row) => damageToTypeLabels.includes(row.label));

  const damageFromTypeLabels = damageFromTypes.map((type) => type.label);
  const damageFroms =
    damageFromTypeLabels.length === 0
      ? DAMAGE_TYPES
      : DAMAGE_TYPES.filter((row) => damageFromTypeLabels.includes(row.label));

  const headers = createHeaders(damageFroms);
  const rows = damageTos.map((damageTo) => createRow(damageTo, damageFroms));

  function createHeaders(damageFroms: DamageType[]) {
    const headers = damageFroms.map((type) => ({
      value: type.label,
    }));
    headers.unshift({ value: "" });
    return headers;
  }

  function createRow(damageTo: DamageType, damageFroms: DamageType[]) {
    const typeToDamageValue = createTypeToDamageValue(damageFroms);
    for (const type of damageTo.damage.double_to) {
      const damage = typeToDamageValue.get(type);
      if (damage) {
        damage.value = "⚪︎";
      }
    }
    for (const type of damageTo.damage.half_to) {
      const damage = typeToDamageValue.get(type);
      if (damage) {
        damage.value = "△";
      }
    }
    for (const type of damageTo.damage.no_to) {
      const damage = typeToDamageValue.get(type);
      if (damage) {
        damage.value = "×";
      }
    }

    const cells = [...typeToDamageValue.values()]
      .sort((a, b) => a.order - b.order)
      .map((damage) => ({
        value: damage.value,
      }));
    cells.unshift({ value: damageTo.label });
    return {
      cells,
    };
  }

  return (
    <>
      <ColumnBase mb={1}>
        <HStack justifyContent={"center"}>
          <div style={{ textAlign: "left" }}>
            <FormControl label="与えるダメージ" fieldId="damageToMultiComboBox">
              <MultiComboBox
                id="damageToMultiComboBox"
                values={damageToTypes}
                width={"large"}
                options={options}
                onChange={(e) => {
                  setDamageToTypes(e);
                }}
              />
            </FormControl>
          </div>
          <div style={{ textAlign: "left" }}>
            <FormControl
              label="与えられるダメージ"
              fieldId="damageFromMultiComboBox"
            >
              <MultiComboBox
                id="damageFromMultiComboBox"
                values={damageFromTypes}
                width={"large"}
                options={options}
                onChange={(e) => {
                  setDamageFromTypes(e);
                }}
              />
            </FormControl>
          </div>
        </HStack>
      </ColumnBase>

      <Text weight="bold">与えられるダメージ</Text>
      <HStack justifyContent={"center"}>
        <div
          style={{
            writingMode: "vertical-rl",
            textAlign: "center",
            display: "inline-block",
          }}
        >
          <Text weight="bold">与えるダメージ</Text>
        </div>
        <div style={{ display: "inline-block", width: "90%" }}>
          <ScrollableBase scrollableX>
            <NumericTable
              fixedHeader
              fixedRowHeader
              rowHeaderCount={1}
              headers={headers}
              rows={rows}
            />
          </ScrollableBase>
        </div>
      </HStack>
    </>
  );
}

const DAMAGE_TYPES = [
  {
    id: 1,
    label: "ノーマル",
    value: "normal",
    damage: {
      double_from: ["fighting"],
      double_to: [],
      half_from: [],
      half_to: ["rock", "steel"],
      no_from: ["ghost"],
      no_to: ["ghost"],
    },
  },
  {
    id: 2,
    label: "ほのお",
    value: "fire",
    damage: {
      double_from: ["ground", "rock", "water"],
      double_to: ["bug", "steel", "grass", "ice"],
      half_from: ["bug", "steel", "fire", "grass", "ice", "fairy"],
      half_to: ["rock", "fire", "water", "dragon"],
      no_from: [],
      no_to: [],
    },
  },
  {
    id: 3,
    label: "みず",
    value: "water",
    damage: {
      double_from: ["grass", "electric"],
      double_to: ["ground", "rock", "fire"],
      half_from: ["steel", "fire", "water", "ice"],
      half_to: ["water", "grass", "dragon"],
      no_from: [],
      no_to: [],
    },
  },
  {
    id: 4,
    label: "でんき",
    value: "electric",
    damage: {
      double_from: ["ground"],
      double_to: ["flying", "water"],
      half_from: ["flying", "steel", "electric"],
      half_to: ["grass", "electric", "dragon"],
      no_from: [],
      no_to: ["ground"],
    },
  },
  {
    id: 5,
    label: "くさ",
    value: "grass",
    damage: {
      double_from: ["flying", "poison", "bug", "fire", "ice"],
      double_to: ["ground", "rock", "water"],
      half_from: ["ground", "water", "grass", "electric"],
      half_to: ["flying", "poison", "bug", "steel", "fire", "grass", "dragon"],
      no_from: [],
      no_to: [],
    },
  },
  {
    id: 6,
    label: "こおり",
    value: "ice",
    damage: {
      double_from: ["fighting", "rock", "steel", "fire"],
      double_to: ["flying", "ground", "grass", "dragon"],
      half_from: ["ice"],
      half_to: ["steel", "fire", "water", "ice"],
      no_from: [],
      no_to: [],
    },
  },
  {
    id: 7,
    label: "かくとう",
    value: "fighting",
    damage: {
      double_from: ["flying", "psychic", "fairy"],
      double_to: ["normal", "rock", "steel", "ice", "dark"],
      half_from: ["rock", "bug", "dark"],
      half_to: ["flying", "poison", "bug", "psychic", "fairy"],
      no_from: [],
      no_to: ["ghost"],
    },
  },
  {
    id: 8,
    label: "どく",
    value: "poison",
    damage: {
      double_from: ["ground", "psychic"],
      double_to: ["grass", "fairy"],
      half_from: ["fighting", "poison", "bug", "grass", "fairy"],
      half_to: ["poison", "ground", "rock", "ghost"],
      no_from: [],
      no_to: ["steel"],
    },
  },
  {
    id: 9,
    label: "じめん",
    value: "ground",
    damage: {
      double_from: ["water", "grass", "ice"],
      double_to: ["poison", "rock", "steel", "fire", "electric"],
      half_from: ["poison", "rock"],
      half_to: ["bug", "grass"],
      no_from: ["electric"],
      no_to: ["flying"],
    },
  },
  {
    id: 10,
    label: "ひこう",
    value: "flying",
    damage: {
      double_from: ["rock", "electric", "ice"],
      double_to: ["fighting", "bug", "grass"],
      half_from: ["fighting", "bug", "grass"],
      half_to: ["rock", "steel", "electric"],
      no_from: ["ground"],
      no_to: [],
    },
  },
  {
    id: 11,
    label: "エスパー",
    value: "psychic",
    damage: {
      double_from: ["bug", "ghost", "dark"],
      double_to: ["fighting", "poison"],
      half_from: ["fighting", "psychic"],
      half_to: ["steel", "psychic"],
      no_from: [],
      no_to: ["dark"],
    },
  },
  {
    id: 12,
    label: "むし",
    value: "bug",
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
  },
  {
    id: 13,
    label: "いわ",
    value: "rock",
    damage: {
      double_from: ["fighting", "ground", "steel", "water", "grass"],
      double_to: ["flying", "bug", "fire", "ice"],
      half_from: ["normal", "flying", "poison", "fire"],
      half_to: ["fighting", "ground", "steel"],
      no_from: [],
      no_to: [],
    },
  },
  {
    id: 14,
    label: "ゴースト",
    value: "ghost",
    damage: {
      double_from: ["ghost", "dark"],
      double_to: ["ghost", "psychic"],
      half_from: ["poison", "bug"],
      half_to: ["dark"],
      no_from: ["normal", "fighting"],
      no_to: ["normal"],
    },
  },
  {
    id: 15,
    label: "ドラゴン",
    value: "dragon",
    damage: {
      double_from: ["ice", "dragon", "fairy"],
      double_to: ["dragon"],
      half_from: ["fire", "water", "grass", "electric"],
      half_to: ["steel"],
      no_from: [],
      no_to: ["fairy"],
    },
  },
  {
    id: 16,
    label: "あく",
    value: "dark",
    damage: {
      double_from: ["fighting", "bug", "fairy"],
      double_to: ["ghost", "psychic"],
      half_from: ["ghost", "dark"],
      half_to: ["fighting", "dark", "fairy"],
      no_from: ["psychic"],
      no_to: [],
    },
  },
  {
    id: 17,
    label: "はがね",
    value: "steel",
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
  },
  {
    id: 18,
    label: "フェアリー",
    value: "fairy",
    damage: {
      double_from: ["poison", "steel"],
      double_to: ["fighting", "dragon", "dark"],
      half_from: ["fighting", "bug", "dark"],
      half_to: ["poison", "steel", "fire"],
      no_from: ["dragon"],
      no_to: [],
    },
  },
];

export default DamageTable;
