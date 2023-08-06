import { useEffect, useState } from "react";
import "./book.scss";
import { useNavigate, useParams } from "react-router-dom";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faChevronRight } from "@fortawesome/free-solid-svg-icons";
import { format } from "date-fns";
import HotelBook from "../../components/hotelBook/HotelBook";
import Navbar from "../../components/navbar/Navbar";
import { publicRequest } from "../../request";
import { useGlobalContext } from "../../context/useGlobalContext";

const Book = () => {
  const { id } = useParams();
  const { dates } = useGlobalContext();
  const navigate = useNavigate();
  const [roomHotel, setRoomHotel] = useState({});

  useEffect(() => {
    window.scrollTo(0, 0);
    const getHotelBook = async () => {
      try {
        const res = await publicRequest.get("/rooms/" + id);
        setRoomHotel(res.data.data);
      } catch (error) {
        console.log(error);
      }
    };
    getHotelBook();
  }, [id]);

  const bookRoom = async () => {
    const user = JSON.parse(localStorage.getItem("user"));
    if (!user) {
      navigate("/login");
    }
    const data = {
      typeId: roomHotel.MaLoaiPhong,
      userId: user.MaTaiKhoan,
      checkIn: format(dates[0].startDate, "MM/dd/yyyy"),
      checkOut: format(dates[0].endDate, "MM/dd/yyyy"),
    };
    try {
      const res = await publicRequest.post("/rooms/book", data);
      alert(res.data.msg);
      navigate("/booked");
    } catch (error) {
      console.log(error);
    }
  };

  return (
    <>
      <Navbar />
      <div className="bookContainer">
        <div className="bookWrapper">
          <div className="bookResult">
            <div className="bookTitle">
              <h2>Tiến hành đặt phòng</h2>
            </div>
            <div className="userInfo">
              <p>
                Họ tên người đặt:{" "}
                <b>{JSON.parse(localStorage.getItem("user")).HoTen}</b>
              </p>
              <p>
                Số điện thoại người đặt:{" "}
                <b>{JSON.parse(localStorage.getItem("user")).SDT}</b>
              </p>
            </div>
            <HotelBook roomHotel={roomHotel} dates={dates} />
            <button className="bookButton" onClick={bookRoom}>
              Xác nhận đặt phòng <FontAwesomeIcon icon={faChevronRight} />
            </button>
          </div>
        </div>
      </div>
    </>
  );
};

export default Book;
