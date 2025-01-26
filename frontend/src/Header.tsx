import { GlobalNavi } from "@freee_jp/vibes";
import { useState } from "react";
import { useNavigate } from "react-router-dom";

type Page = "pokemons" | "damage";

export function Header() {
  const navigate = useNavigate();
  const [currentPage, setCurrentPage] = useState<Page>(
    location.pathname.replace("/", "") as Page
  );

  return (
    <GlobalNavi
      mb={2}
      links={[
        {
          title: "ポケモンリスト",
          url: "/pokemons",
          // IconComponent: MdHome,
          current: currentPage == "pokemons",
          onSelfWindowNavigation: () => {
            setCurrentPage("pokemons");
            navigate(`/pokemons`);
          },
        },
        {
          title: "ダメージ",
          url: "/damage",
          // IconComponent: MdHome,
          current: currentPage == "damage",
          onSelfWindowNavigation: () => {
            setCurrentPage("damage");
            navigate(`/damage`);
          },
        },
      ]}
      hideHelpForm
    />
  );
}

export default Header;
