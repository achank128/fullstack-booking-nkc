import { Link } from "react-router-dom";
import "./hotelItem.scss";
import { faLeaf, faChevronRight } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useGlobalContext } from "../../context/useGlobalContext";

const HotelItem = ({ hotel }) => {
  const { getStar } = useGlobalContext();

  return (
    <div className="hotelItem">
      <Link to={`/hotels/${hotel.MaKhachSan}`}>
        <img src={hotel.Anh} alt="Anh" className="siImg" />
      </Link>
      <div className="siDesc">
        <Link to={`/hotels/${hotel.MaKhachSan}`}>
          <h1 className="siTitle">
            {hotel.TenKhachSan}{" "}
            <span className="star">
              {getStar(hotel.ChatLuong).map((i) => i)}
            </span>
          </h1>
        </Link>
        <span className="siDistance">{hotel.DiaChi}</span>
        <span className="siSubtitle">
          <FontAwesomeIcon icon={faLeaf} /> Chỗ nghỉ Du lịch bền vững
        </span>
        <span className="siFeatures">{hotel.MoTa}</span>
      </div>
      <div className="siDetails">
        <div className="siRating">
          <span>{hotel.SoDanhGia} đánh giá</span>
          <button className="siRatingNumber">{hotel.DanhGia} </button>
        </div>

        <div className="siDetailTexts">
          <Link to={`/hotels/${hotel.MaKhachSan}`}>
            <button className="siCheckButton">
              Xem chỗ trống <FontAwesomeIcon icon={faChevronRight} />
            </button>
          </Link>
        </div>
      </div>
    </div>
  );
};

export default HotelItem;
