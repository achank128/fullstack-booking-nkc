import "./hotel.scss";
import { useEffect, useState } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faLocationDot,
  faCrown,
  faCalendarDays,
} from "@fortawesome/free-solid-svg-icons";
import { useParams } from "react-router-dom";
import { format } from "date-fns";
import { publicRequest } from "../../request";
import { useGlobalContext } from "../../context/useGlobalContext";
//components
import Navbar from "../../components/navbar/Navbar";
import Header from "../../components/header/Header";
import MailList from "../../components/mailList/MailList";
import Footer from "../../components/footer/Footer";
import Room from "../../components/room/Room";
import ListSearch from "../../components/listSearch/ListSearch";
//date picker
import { DateRange } from "react-date-range"; //date
import "react-date-range/dist/styles.css"; // main css file
import "react-date-range/dist/theme/default.css"; // theme css file

const Hotel = () => {
  const { getStar, dates, setDates } = useGlobalContext();
  const { id } = useParams();
  const [hotel, setHotel] = useState([]);
  const [service, setService] = useState([]);
  const [rooms, setRooms] = useState([]);
  const [openDate, setOpenDate] = useState(false);

  const getHotel = async () => {
    try {
      const res = await publicRequest.get("/hotels/" + id);
      setHotel(res.data.data);
    } catch (error) {
      console.log(error);
    }
  };
  const getService = async () => {
    try {
      const res = await publicRequest.get("/hotels/service/" + id);
      setService(res.data.data);
    } catch (error) {
      console.log(error);
    }
  };
  const getRooms = async () => {
    try {
      const res = await publicRequest.get("/hotels/room/" + id);
      setRooms(res.data.data);
    } catch (error) {
      console.log(error);
    }
  };
  useEffect(() => {
    window.scrollTo(0, 0);
    getService();
    getRooms();
    getHotel();
  }, []);

  return (
    <>
      <Navbar />
      <Header type="list" />
      {hotel ? (
        <div className="hotelContainer">
          <div className="hotelContent">
            <ListSearch />

            <div className="hotelWrapper">
              <button className="btnBookNow">Đặt ngay</button>

              <div className="hotelStar">
                <span className="type">Khách sạn</span>
                <span className="star">
                  {getStar(hotel.ChatLuong).map((i) => i)}
                </span>
              </div>
              <h1 className="hotelTitle">{hotel.TenKhachSan}</h1>
              <div className="hotelAddress">
                <span>
                  <FontAwesomeIcon icon={faLocationDot} />
                </span>
                {hotel.DiaChi}
              </div>
              <span className="hotelDistance">
                Vị trí tuyệt vời - Hiển thị trên bản đồ
              </span>
              <div className="hotelImage">
                <img src={hotel.Anh} alt="" className="hotelImg" />
              </div>
            </div>
          </div>
          <div className="hotelDetails">
            <div className="hotelDesc">
              <p>{hotel.MoTa}</p>
              <div className="hotelService">
                <h3>Các tiện nghi được ưa chuộng nhất</h3>
                <div className="hotelServiceList">
                  {service.map((s) => (
                    <span className="item" key={s.MaDichVu}>
                      <span>
                        <FontAwesomeIcon icon={faCrown} />
                      </span>{" "}
                      {s.TenDichVu}
                    </span>
                  ))}
                </div>
                <p>
                  <b>Dịch vụ Thu Đổi Ngoại Tệ:</b> Bạn cần tiền địa phương? Chỗ
                  nghỉ này có dịch vụ Thu Đổi Ngoại Tệ trong khuôn viên.
                </p>
              </div>
            </div>

            <div className="genius">
              <h1>Lợi ích Genius có ở một số lựa chọn:</h1>
              <span>Giảm giá 10% - Áp dụng trên giá trước thuế và phí</span>
            </div>
          </div>

          <div className="hotelRoom">
            <h2>Phòng trống</h2>
            <div className="hotelRoomSearch">
              <div className="hotelRoomDate">
                <FontAwesomeIcon icon={faCalendarDays} className="headerIcon" />
                <span
                  onClick={() => setOpenDate(!openDate)}
                  className="hotelRoomText"
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
              <button
                className="hotelRoomBtn"
                onClick={() => setOpenDate(!openDate)}
              >
                Chọn
              </button>
            </div>
            <div className="hotelRoomTable">
              <table>
                <thead>
                  <tr>
                    <th>Loại phòng</th>
                    <th>Phù hợp cho</th>
                    <th>Giá phòng</th>
                    <th>Còn trống</th>
                    <th>Đặt</th>
                  </tr>
                </thead>
                <tbody>
                  {rooms.map((r) => (
                    <Room room={r} key={r.MaLoaiPhong} />
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      ) : null}
      {/* {openModal && <Reserve setOpen={setOpenModal} hotelId={id} />} */}
      <MailList />
      <Footer />
    </>
  );
};

export default Hotel;
