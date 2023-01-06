import { Link } from "react-router-dom";
import "./locationList.scss";

const LocationList = ({ locations }) => {
  return (
    <div className="locationList container">
      {locations.map((location) => (
        <div className="locationListItem" key={location.MaDiaDiem}>
          <Link style={{textDecoration: 'none'}} to={`/hotels?location=${location.MaDiaDiem}`}>
            <img src={location.Anh} alt="" className="locationListImg"/>
            <div className="locationTitle">
              {location.TenDiaDiem}
            </div>
          </Link>
        </div>
      ))}
    </div>
  );
};

export default LocationList;
