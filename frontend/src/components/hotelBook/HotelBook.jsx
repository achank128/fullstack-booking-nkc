import { Link } from "react-router-dom";
import "./hotelBook.scss";
import { useGlobalContext } from "../../context/useGlobalContext";
import { format } from "date-fns";

const HotelBook = ({ roomHotel, dates }) => {
  const { getStar, formater, getPeople } = useGlobalContext();

  return (
    <div className="hotelBook">
      <Link to={`/hotels/${roomHotel.MaKhachSan}`}>
        <img src={roomHotel.Anh} alt="Anh" className="img" />
      </Link>
      <div className="desc">
        <h2 className="title">{roomHotel.TenLoaiPhong}</h2>
        <p className="bed">
          <b>{roomHotel.SoGiuong}</b>{" "}
          <span>{getPeople(roomHotel.SoNguoi).map((i) => i)}</span>
        </p>
        <p>Giá: {formater.format(roomHotel.GiaPhong)} VND/Đêm</p>
        <span className="features">{roomHotel.MoTa}</span>
        <Link to={`/hotels/${roomHotel.MaKhachSan}`}>
          <h3 className="title">
            {roomHotel.TenKhachSan}{" "}
            <span className="star">
              {getStar(roomHotel.ChatLuong).map((i) => i)}
            </span>
          </h3>
        </Link>
        <span className="address">{roomHotel.DiaChi}</span>
      </div>
      {dates ? (
        <div className="details">
          <div className="dates">
            {format(dates[0].startDate, "dd/MM/yyyy")}
            {" - "}
            {format(dates[0].endDate, "dd/MM/yyyy")}
          </div>
          <div className="total">
            <p>
              Số đêm:{" "}
              {(dates[0].endDate - dates[0].startDate) / (1000 * 60 * 60 * 24)}
            </p>
            <p className="price">
              Tổng:{" "}
              {formater.format(
                (roomHotel.GiaPhong * (dates[0].endDate - dates[0].startDate)) /
                  (1000 * 60 * 60 * 24)
              )}
              VND
            </p>
          </div>
        </div>
      ) : (
        <div className="details">
          <div className="dates">
            {roomHotel.NgayCheckin.slice(0, 10)}
            {" - "}
            {roomHotel.NgayCheckout.slice(0, 10)}
          </div>
          <div className="total">
            <p>Số đêm: {roomHotel.SoDem}</p>
            <p className="price">
              Tổng: {formater.format(roomHotel.TongTien)} VND
            </p>
          </div>
        </div>
      )}
    </div>
  );
};

export default HotelBook;
