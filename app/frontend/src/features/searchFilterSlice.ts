import type { PayloadAction } from "@reduxjs/toolkit";
import { createSlice } from "@reduxjs/toolkit";
import { Region } from "../types/api";

export type SearchFilter = {
  id: number;
  name: string;
  region: Region;
};

const searchFilterSlice = createSlice({
  name: "searchFilter",
  initialState: { id: -1, name: "", region: "kanto" as Region },
  reducers: {
    searchFilterUpdated(state, action: PayloadAction<SearchFilter>) {
      state.region = action.payload.region;
      state.id = action.payload.id;
      state.name = action.payload.name;
    },
  },
});

export const { searchFilterUpdated } = searchFilterSlice.actions;
export default searchFilterSlice.reducer;
