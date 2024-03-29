import i18n from "i18next";
import { initReactI18next } from "react-i18next";

// the translations
// (tip move them in a JSON file and import them,
// or even better, manage them separated from your code: https://react.i18next.com/guides/multiple-translation-files)
const resources = {
  ja: {
    translation: {
      pokedex: {
        "letsgo-kanto": "カントー",
        "updated-johto": "ジョート",
        galar: "ガラル",
        "isle-of-armor": "ヨロイじま",
        "crown-tundra": "カンムリせつげん",
        paldea: "パルデア",
        kitakami: "キタカミ",
        blueberry: "ブルーベリー",
      },
      type: {
        normal: "ノーマル",
        fighting: "かくとう",
        flying: "ひこう",
        poison: "どく",
        ground: "じめん",
        rock: "いわ",
        bug: "むし",
        ghost: "ゴースト",
        steel: "はがね",
        fire: "ほのお",
        water: "みず",
        grass: "くさ",
        electric: "でんき",
        psychic: "エスパー",
        ice: "こおり",
        dragon: "ドラゴン",
        dark: "あく",
        fairy: "フェアリー",
        unknown: "？？？",
        shadow: "シャドー",
      },
    },
  },
};

i18n
  .use(initReactI18next) // passes i18n down to react-i18next
  .init({
    resources,
    lng: "ja", // language to use, more information here: https://www.i18next.com/overview/configuration-options#languages-namespaces-resources
    // you can use the i18n.changeLanguage function to change the language manually: https://www.i18next.com/overview/api#changelanguage
    // if you're using a language detector, do not define the lng option

    interpolation: {
      escapeValue: false, // react already safes from xss
    },
  });

export default i18n;
