import { faStar, faUser } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import React, { useReducer, createContext } from "react";
import reducer from "./reducer";

const AppContext = createContext();
const initialState = {
  search: "",
  dates: [
    {
      startDate: new Date(),
      endDate: new Date(),
      // endDate: new Date().setDate(new Date().getDate() + 1),
      key: "selection",
    },
  ],
  book: {},
};
const AppProvider = ({ children }) => {
  const [state, dispatch] = useReducer(reducer, initialState);

  const formater = Intl.NumberFormat("de-DE");

  const getStar = (star) => {
    let starIcon = [];
    for (let i = 0; i < star; i++) {
      starIcon.push(<FontAwesomeIcon key={i} icon={faStar} />);
    }
    return starIcon;
  };

  const getPeople = (num) => {
    let people = [];
    for (let i = 0; i < num; i++) {
      people.push(<FontAwesomeIcon key={i} icon={faUser} />);
    }
    return people;
  };

  const setDates = (dates) => {
    dispatch({ type: "SET_DATE", payload: dates });
  };

  const setSearch = (search) => {
    dispatch({ type: "SET_SEARCH", payload: search });
  };

  return (
    <AppContext.Provider
      value={{
        ...state,
        formater,
        getStar,
        setDates,
        setSearch,
        getPeople,
      }}
    >
      {children}
    </AppContext.Provider>
  );
};
export { AppContext, AppProvider };
