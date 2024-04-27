import { configureStore } from "@reduxjs/toolkit";
import searchFilterReducer from "./features/searchFilterSlice";

export const store = configureStore({
  reducer: {
    searchFilter: searchFilterReducer,
  },
});

// Infer the `RootState` and `AppDispatch` types from the store itself
export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
