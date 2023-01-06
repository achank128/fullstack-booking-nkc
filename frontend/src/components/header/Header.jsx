import { faBed, faCalendarDays } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import "./header.scss";
import { useState } from "react";
import { DateRange } from "react-date-range";
import "react-date-range/dist/styles.css"; // main css file
import "react-date-range/dist/theme/default.css"; // theme css file
import { format } from "date-fns";
import { Link, useNavigate } from "react-router-dom";
import { useGlobalContext } from "../../context/useGlobalContext";

const Header = ({ type }) => {
  const [openDate, setOpenDate] = useState(false);
  const { search, setSearch, dates, setDates } = useGlobalContext();
  const user = JSON.parse(localStorage.getItem("user"));

  const navigate = useNavigate();
  const handleSearch = () => {
    navigate("/hotels?search=" + search);
  };

  return (
    <div className="header ">
      <div
        className={
          type === "list"
            ? "headerContainer container listMode"
            : "headerContainer container"
        }
      >
        <div className="headerList">
          <div className="headerListItem active">
            <FontAwesomeIcon icon={faBed} />
            <span>Lưu trú</span>
          </div>
        </div>
        {type !== "list" && (
          <>
            <h1 className="headerTitle">Tìm chỗ nghỉ tiếp theo</h1>
            <p className="headerDesc">
              Tìm ưu đãi Genius đặc biệt tại khắp nơi trên thế giới!
            </p>
            {user ? null : (
              <Link to="/login">
                <button className="headerBtn">Sign in / Register</button>
              </Link>
            )}
            <div className="headerSearch">
              <div className="headerSearchContent">
                <FontAwesomeIcon icon={faBed} className="headerIcon" />
                <input
                  type="text"
                  placeholder="Bạn muốn đến đâu?"
                  className="headerSearchInput"
                  value={search}
                  onChange={(e) => setSearch(e.target.value)}
                />
              </div>
              <div className="headerSearchDate">
                <FontAwesomeIcon icon={faCalendarDays} className="headerIcon" />
                <span
                  onClick={() => setOpenDate(!openDate)}
                  className="headerSearchText"
                >{`${format(dates[0].startDate, "MM/dd/yyyy")} đến ${format(
                  dates[0].endDate,
                  "MM/dd/yyyy"
                )}`}</span>
                {openDate && (
                  <DateRange
                    editableDateInputs={true}
                    onChange={(item) => setDates([item.selection])}
                    moveRangeOnFirstSelection={false}
                    ranges={dates}
                    className="date"
                    minDate={new Date()}
                  />
                )}
              </div>
              <div className="headerSearchBtn">
                <button className="headerBtn" onClick={handleSearch}>
                  Tìm
                </button>
              </div>
            </div>
          </>
        )}
      </div>
    </div>
  );
};

export default Header;
