import type { PayloadAction } from "@reduxjs/toolkit";
import { createSlice } from "@reduxjs/toolkit";
import { Region } from "../types/api";

export type SearchFilter = {
  name: string;
  region: Region;
};

const searchFilterSlice = createSlice({
  name: "searchFilter",
  initialState: { name: "", region: "kanto" as Region },
  reducers: {
    searchFilterUpdated(state, action: PayloadAction<SearchFilter>) {
      state.region = action.payload.region;
      state.name = action.payload.name;
    },
  },
});

export const { searchFilterUpdated } = searchFilterSlice.actions;
export default searchFilterSlice.reducer;
