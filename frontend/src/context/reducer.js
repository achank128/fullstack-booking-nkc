const reducer = (state, action) => {
  if (action.type === "SET_DATE") {
    return {
      ...state,
      dates: action.payload,
    };
  }

  if (action.type === "SET_SEARCH") {
    return {
      ...state,
      search: action.payload,
    };
  }

  throw new Error("no matching action type");
};

export default reducer;
