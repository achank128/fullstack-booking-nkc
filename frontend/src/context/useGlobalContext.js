import { useContext } from "react";
import { AppContext } from "./context";
export const useGlobalContext = () => {
  return useContext(AppContext);
};
