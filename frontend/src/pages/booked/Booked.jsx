import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import "./booked.scss";
import { publicRequest } from "../../request";
import HotelBook from "../../components/hotelBook/HotelBook";
import Navbar from "../../components/navbar/Navbar";

const Booked = () => {
  const navigate = useNavigate();
  const [booked, setBooked] = useState([]);
  const user = JSON.parse(localStorage.getItem("user"));

  useEffect(() => {
    window.scrollTo(0, 0);
    if (!user) {
      navigate("/login");
    }
    const getBooked = async () => {
      try {
        const res = await publicRequest.get("/rooms/booked/" + user.MaTaiKhoan);
        setBooked(res.data.data);
      } catch (error) {
        console.log(error);
      }
    };
    getBooked();
  }, []);

  return (
    <>
      <Navbar />
      <div className="bookedContainer">
        <div className="bookedWrapper">
          <div className="bookedResult">
            <div className="bookedTitle">
              <h2>Danh sách phòng đặt</h2>
            </div>
            {booked &&
              booked.map((b) => <HotelBook roomHotel={b} key={b.MaDat} />)}
          </div>
        </div>
      </div>
    </>
  );
};

export default Booked;
