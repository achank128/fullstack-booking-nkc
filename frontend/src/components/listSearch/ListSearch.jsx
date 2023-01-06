import React, { useState } from "react";
import "./listSearch.scss";
import { format } from "date-fns";
import { DateRange } from "react-date-range";
import "react-date-range/dist/styles.css"; // main css file
import "react-date-range/dist/theme/default.css"; // theme css file
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faCalendarDays } from "@fortawesome/free-solid-svg-icons";
import { useGlobalContext } from "../../context/useGlobalContext";
import { useNavigate } from "react-router-dom";

const ListSearch = () => {
  const { search, setSearch, dates, setDates } = useGlobalContext();
  const [openDate, setOpenDate] = useState(false);

  const navigate = useNavigate();
  const handleSearch = () => {
    navigate("/hotels?search=" + search);
  };

  return (
    <div className="searchDate">
      <h1 className="title">Tìm</h1>
      <div className="itemInput">
        <label>Chỗ nghỉ / điểm đến:</label>
        <input
          className="searchInput"
          type="text"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
        />
      </div>
      <div className="itemInput">
        <label>Ngày nhận / trả:</label>
        <span className="selectInput" onClick={() => setOpenDate(!openDate)}>
          <FontAwesomeIcon
            icon={faCalendarDays}
            style={{ marginRight: "8px" }}
          />
          {`${format(dates[0].startDate, "MM/dd/yyyy")} to ${format(
            dates[0].endDate,
            "MM/dd/yyyy"
          )}`}
        </span>
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
      {/* <div className="lsItem">
        <label>Options</label>
        <div className="lsOptions">
          <div className="lsOptionItem">
            <span className="lsOptionText">
              Min price <small>per night</small>
            </span>
            <input
              type="number"
              // onChange={(e) => setMin(e.target.value)}
              className="lsOptionInput"
            />
          </div>
          <div className="lsOptionItem">
            <span className="lsOptionText">
              Max price <small>per night</small>
            </span>
            <input
              type="number"
              // onChange={(e) => setMax(e.target.value)}
              className="lsOptionInput"
            />
          </div>
          <div className="lsOptionItem">
            <span className="lsOptionText">Adult</span>
            <input
              type="number"
              min={1}
              className="lsOptionInput"
              // placeholder={options.adult}
            />
          </div>
          <div className="lsOptionItem">
            <span className="lsOptionText">Children</span>
            <input
              type="number"
              min={0}
              className="lsOptionInput"
              // placeholder={options.children}
            />
          </div>
          <div className="lsOptionItem">
            <span className="lsOptionText">Room</span>
            <input
              type="number"
              min={1}
              className="lsOptionInput"
              // placeholder={options.room}
            />
          </div>
        </div>
      </div> */}
      <button className="button" onClick={handleSearch}>
        Tìm
      </button>
    </div>
  );
};

export default ListSearch;
