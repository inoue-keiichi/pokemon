import React from "react";
import ReactDOM from "react-dom/client";
import { Provider } from "react-redux";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import Damage from "../src/Damage";
import Header from "../src/Header";
import Pokemon from "../src/Pokemon";
import PokemonList from "../src/PokemonList";
import "../src/index.css";
import { store } from "../src/store";
import "./i18n";

fetch("api/token").then((res) => {
  const csrfToken = res.headers.get("x-csrf-token") || "";

  ReactDOM.createRoot(document.getElementById("root")!).render(
    <React.StrictMode>
      <Provider store={store}>
        <BrowserRouter>
          <Header />
          <Routes>
            <Route
              path="/pokemons"
              element={<PokemonList csrfToken={csrfToken} />}
            />
            <Route path="/pokemons/:id" element={<Pokemon />} />
            <Route path="/damage" element={<Damage />} />
            <Route path="*" element={<PokemonList csrfToken={csrfToken} />} />
          </Routes>
        </BrowserRouter>
      </Provider>
    </React.StrictMode>
  );
});
