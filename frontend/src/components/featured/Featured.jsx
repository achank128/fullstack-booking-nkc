import { Link } from "react-router-dom";
import "./featured.scss";

const Featured = ({ locations }) => {
  return (
    <div className="featured container">
      <>
        {locations.map((location) => (
          <div className="featuredItem" key={location.MaDiaDiem}>
            <Link to={`/hotels?location=${location.MaDiaDiem}`}>
              <img src={location.Anh} alt="" className="featuredImg" />
              <div className="featuredTitles">
                <h2>{location.TenDiaDiem}</h2>
              </div>
            </Link>
          </div>
        ))}
      </>
    </div>
  );
};

export default Featured;
