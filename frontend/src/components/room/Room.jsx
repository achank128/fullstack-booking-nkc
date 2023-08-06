import React, { useEffect } from "react";
import "./room.scss";
import { faUser, faBed } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useState } from "react";
import { publicRequest } from "../../request";
import { useGlobalContext } from "../../context/useGlobalContext";
import { format } from "date-fns";
import { Link } from "react-router-dom";

const Room = ({ room }) => {
  const { formater, dates, getPeople } = useGlobalContext();

  const [roomTitle, setRoomTitle] = useState([]);
  const getRooms = async () => {
    const data = {
      typeId: room.MaLoaiPhong,
      checkIn: format(dates[0].startDate, "MM/dd/yyyy"),
      checkOut: format(dates[0].endDate, "MM/dd/yyyy"),
    };
    try {
      const res = await publicRequest.post("/rooms/avaiable", data);
      setRoomTitle(res.data.data);
    } catch (error) {
      console.log(error);
    }
  };
  useEffect(() => {
    getRooms();
  }, [dates]);

  return (
    <tr className="roomItem">
      <td>
        <div className="roomInfo">
          <h3>{room.TenLoaiPhong}</h3>
          <p>
            <FontAwesomeIcon icon={faBed} /> {room.SoGiuong}
          </p>
          <p className="desc">{room.MoTa}</p>
        </div>
      </td>
      <td>
        <span>{getPeople(room.SoNguoi).map((i) => i)}</span>
      </td>
      <td>
        <h4>VND {formater.format(room.GiaPhong)}</h4>
        <p className="price-desc">Đã bao gồm thuế và phí</p>
      </td>
      <td>
        {roomTitle.length > 0 ? (
          <p>{roomTitle.length} Phòng</p>
        ) : (
          <p className="roomError">Hết Phòng</p>
        )}
      </td>
      <td>
        <Link to={`/book/${room.MaLoaiPhong}`}>
          <button className="bookRoomBtn">Đặt Phòng Này</button>
        </Link>
      </td>
    </tr>
  );
};

export default Room;
