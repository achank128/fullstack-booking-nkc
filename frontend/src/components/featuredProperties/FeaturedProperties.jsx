import "./featuredProperties.scss";

const FeaturedProperties = ({ topHotels }) => {
  return (
    <div className="fp container">
      {topHotels.map((hotel) => (
        <div className="fpItem" key={hotel.MaKhachSan}>
          <img src={hotel.Anh} alt="" className="fpImg" />
          <span className="fpName">{hotel.TenKhachSan}</span>
          <span className="fpCity">{hotel.DiaChi}</span>
          <div className="fpRating">
            <button>{hotel.DanhGia}</button>
            <span>{hotel.SoDanhGia} Đánh giá</span>
          </div>
        </div>
      ))}
    </div>
  );
};

export default FeaturedProperties;
