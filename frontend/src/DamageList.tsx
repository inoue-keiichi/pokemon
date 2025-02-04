import {
  HStack,
  ListTable,
  MultiComboBoxOption,
  VStack,
} from "@freee_jp/vibes";
import { t } from "i18next";
import { DAMAGE_TYPES } from "./Damage";
import "./DamageTable.css";

export type Props = {
  damageToTypes: MultiComboBoxOption[];
  damageFromTypes: MultiComboBoxOption[];
};

export function DamageList(props: Props) {
  const { damageToTypes, damageFromTypes } = props;

  const damageToTypeLabels = damageToTypes.map((type) => type.label);
  const damageTos =
    damageToTypeLabels.length === 0
      ? []
      : DAMAGE_TYPES.filter((row) => damageToTypeLabels.includes(row.label));

  const damageFromTypeLabels = damageFromTypes.map((type) => type.label);
  const damageFroms =
    damageFromTypeLabels.length === 0
      ? []
      : DAMAGE_TYPES.filter((row) => damageFromTypeLabels.includes(row.label));

  const damageToValueMap = new Map<string, number>();
  for (const dt of DAMAGE_TYPES) {
    damageToValueMap.set(dt.value, 1);
  }
  for (const damageTo of damageTos) {
    for (const key of damageTo.damage.double_to) {
      const value = damageToValueMap.get(key)!;
      damageToValueMap.set(key, value * 2);
    }
    for (const key of damageTo.damage.half_to) {
      const value = damageToValueMap.get(key)!;
      damageToValueMap.set(key, value * 0.5);
    }
    for (const key of damageTo.damage.no_to) {
      const value = damageToValueMap.get(key)!;
      damageToValueMap.set(key, value * 0);
    }
  }
  const damageTo = (() => {
    const doubles: string[] = [];
    const ones: string[] = [];
    const zeros: string[] = [];
    const halfs: string[] = [];
    damageToValueMap.forEach((value, key) => {
      switch (value) {
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
        default:
          throw new Error("unkown multiple number");
      }
    });
    return [
      { cells: [{ value: "2" }, { value: doubles.join(", ") }] },
      { cells: [{ value: "1" }, { value: ones.join(", ") }] },
      { cells: [{ value: "0.5" }, { value: halfs.join(", ") }] },
      { cells: [{ value: "0" }, { value: zeros.join(", ") }] },
    ];
  })();

  const damageFromValueMap = new Map<string, number>();
  for (const dt of DAMAGE_TYPES) {
    damageFromValueMap.set(dt.value, 1);
  }
  for (const damageFrom of damageFroms) {
    for (const key of damageFrom.damage.double_from) {
      const value = damageFromValueMap.get(key)!;
      damageFromValueMap.set(key, value * 2);
    }
    for (const key of damageFrom.damage.half_from) {
      const value = damageFromValueMap.get(key)!;
      damageFromValueMap.set(key, value * 0.5);
    }
    for (const key of damageFrom.damage.no_from) {
      const value = damageFromValueMap.get(key)!;
      damageFromValueMap.set(key, value * 0);
    }
  }
  const damageFrom = (() => {
    const fourTimes: string[] = [];
    const doubles: string[] = [];
    const ones: string[] = [];
    const zeros: string[] = [];
    const halfs: string[] = [];
    const quarters: string[] = [];
    damageFromValueMap.forEach((value, key) => {
      switch (value) {
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
    });
    return [
      { cells: [{ value: "4" }, { value: fourTimes.join(", ") }] },
      { cells: [{ value: "2" }, { value: doubles.join(", ") }] },
      { cells: [{ value: "1" }, { value: ones.join(", ") }] },
      { cells: [{ value: "0.5" }, { value: halfs.join(", ") }] },
      { cells: [{ value: "0.25" }, { value: quarters.join(", ") }] },
      { cells: [{ value: "0" }, { value: zeros.join(", ") }] },
    ];
  })();

  return (
    <>
      {damageToTypes.length > 0 && (
        <HStack justifyContent={"center"} mt={1}>
          <VStack alignItems={"center"}>
            <h2>与えるダメージ</h2>
            <ListTable
              headers={[
                {
                  value: "倍率",
                },
                {
                  value: "タイプ",
                },
              ]}
              rows={damageTo}
            />
          </VStack>
        </HStack>
      )}

      {damageFromTypes.length > 0 && (
        <HStack justifyContent={"center"} mt={1}>
          <VStack alignItems={"center"}>
            <h2>与えられるダメージ</h2>
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
          </VStack>
        </HStack>
      )}
    </>
  );
}

export default DamageList;
