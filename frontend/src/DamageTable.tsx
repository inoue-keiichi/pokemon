import {
  HStack,
  MultiComboBoxOption,
  NumericTable,
  ScrollableBase,
  Text,
} from "@freee_jp/vibes";
import { DAMAGE_TYPES } from "./Damage";
import "./DamageTable.css";

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

export type Props = {
  damageToTypes: MultiComboBoxOption[];
  damageFromTypes: MultiComboBoxOption[];
};

export function DamageTable(props: Props) {
  const { damageToTypes, damageFromTypes } = props;

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
      value: <span className={"header-cell"}>{type.label}</span>,
    }));
    headers.unshift({ value: <span /> });
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
        noWrap: true,
      }));
    cells.unshift({ value: damageTo.label, noWrap: true });
    return {
      cells,
    };
  }

  return (
    <>
      <Text weight="bold">与えられるダメージ</Text>
      <HStack justifyContent={"center"} mt={1}>
        <div className={"table-attack-subtitle"}>
          <Text weight="bold">与えるダメージ</Text>
        </div>
        <div className={"type-table"}>
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

export default DamageTable;
