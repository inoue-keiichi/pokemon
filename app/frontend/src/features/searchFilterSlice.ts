import type { PayloadAction } from "@reduxjs/toolkit";
import { createSlice } from "@reduxjs/toolkit";

export type SearchFilter = {
  region: string;
};

const searchFilterSlice = createSlice({
  name: "searchFilter",
  initialState: { region: "kanto" },
  reducers: {
    searchFilterUpdated(state, action: PayloadAction<SearchFilter>) {
      state.region = action.payload.region;
      console.log(JSON.stringify(state));
    },
  },
});

export const { searchFilterUpdated } = searchFilterSlice.actions;
export default searchFilterSlice.reducer;
