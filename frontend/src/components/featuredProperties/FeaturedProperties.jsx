import { Link } from "react-router-dom";
import "./featuredProperties.scss";

const FeaturedProperties = ({ topHotels }) => {
  return (
    <div className="fp container">
      {topHotels.map((hotel) => (
        <Link
          className="fpItem"
          key={hotel.MaKhachSan}
          to={`/hotels/${hotel.MaKhachSan}`}
        >
          <img src={hotel.Anh} alt="" className="fpImg" />
          <span className="fpName">{hotel.TenKhachSan}</span>
          <span className="fpCity">{hotel.DiaChi}</span>
          <div className="fpRating">
            <button>{hotel.DanhGia}</button>
            <span>{hotel.SoDanhGia} Đánh giá</span>
          </div>
        </Link>
      ))}
    </div>
  );
};

export default FeaturedProperties;
