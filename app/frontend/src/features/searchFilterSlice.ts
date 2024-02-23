import type { PayloadAction } from "@reduxjs/toolkit";
import { createSlice } from "@reduxjs/toolkit";
import { Region } from "../types/api";

export type SearchFilter = {
  region: Region;
};

const searchFilterSlice = createSlice({
  name: "searchFilter",
  initialState: { region: "kanto" as Region },
  reducers: {
    searchFilterUpdated(state, action: PayloadAction<SearchFilter>) {
      state.region = action.payload.region;
      console.log(JSON.stringify(state));
    },
  },
});

export const { searchFilterUpdated } = searchFilterSlice.actions;
export default searchFilterSlice.reducer;
