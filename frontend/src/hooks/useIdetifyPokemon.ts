import imageCompression from "browser-image-compression";
import { useState } from "react";

export function useIdentifyPokemon(csrfToken: string, file?: File) {
  const [pokemon, setPokemon] = useState<{ id: number; name: string }>();
  const [errMsg, setErrMsg] = useState<string>("");

  if (!file) {
    return;
  }
  if (errMsg !== "") {
    throw Error(errMsg);
  }
  if (csrfToken === "") {
    throw Error("トークンがありません");
  }

  if (pokemon) {
    return pokemon;
  }

  throw imageCompression(file, {
    maxSizeMB: 0.2,
    maxWidthOrHeight: 240,
  })
    .then((file) => {
      return (async () => {
        const body = new FormData();
        body.append("file", file);
        const res = await fetch(`/api/pokemons/identify`, {
          method: "POST",
          body,
          headers: {
            "x-csrf-token": csrfToken,
          },
        });
        if (!res.ok) {
          setErrMsg(await res.json());
        }
        const pokemon = (await res.json()) as { id: number; name: string };
        return pokemon;
      })();
    })
    .then((poke) => setPokemon(poke));
}
