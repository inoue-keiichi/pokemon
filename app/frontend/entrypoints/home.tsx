import React from "react";
import ReactDOM from "react-dom/client";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import Pokemon from "../src/Pokemon";
import PokemonList from "../src/PokemonList";
import "../src/index.css";

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <BrowserRouter>
      <Routes>
        <Route path="/pokemons" element={<PokemonList />} />
        <Route path="/pokemons/:id" element={<Pokemon />} />
        <Route path="*" element={<PokemonList />} />
      </Routes>
    </BrowserRouter>
  </React.StrictMode>
);
