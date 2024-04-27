import type { PayloadAction } from "@reduxjs/toolkit";
import { createSlice } from "@reduxjs/toolkit";
import { VERSION_GROUP } from "../types/api";

export type SearchFilter = {
  id: number;
  name: string;
  version_group: VERSION_GROUP;
};

const searchFilterSlice = createSlice({
  name: "searchFilter",
  initialState: {
    id: -1,
    name: "",
    version_group: "lets-go-pikachu-lets-go-eevee" as VERSION_GROUP,
  },
  reducers: {
    searchFilterUpdated(state, action: PayloadAction<SearchFilter>) {
      state.version_group = action.payload.version_group;
      state.id = action.payload.id;
      state.name = action.payload.name;
    },
  },
});

export const { searchFilterUpdated } = searchFilterSlice.actions;
export default searchFilterSlice.reducer;
