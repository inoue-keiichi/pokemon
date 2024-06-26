import React from "react";
import ReactDOM from "react-dom/client";
import { Provider } from "react-redux";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import DamageTable from "../src/DamageTable";
import Header from "../src/Header";
import Pokemon from "../src/Pokemon";
import PokemonList from "../src/PokemonList";
import "../src/index.css";
import { store } from "../src/store";
import "./i18n";

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <Provider store={store}>
      <BrowserRouter>
        <Header />
        <Routes>
          <Route path="/pokemons" element={<PokemonList />} />
          <Route path="/pokemons/:id" element={<Pokemon />} />
          <Route path="/damage_table" element={<DamageTable />} />
          <Route path="*" element={<PokemonList />} />
        </Routes>
      </BrowserRouter>
    </Provider>
  </React.StrictMode>
);
