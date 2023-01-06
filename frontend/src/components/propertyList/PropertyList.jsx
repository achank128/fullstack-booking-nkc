import { useEffect } from "react";
import { useState } from "react";
import { Link } from "react-router-dom";
import { publicRequest } from "../../request";
import "./propertyList.scss";

const PropertyList = () => {
  const [propterty, setProperty] = useState([]);

  const getProperty = async () => {
    try {
      const res = await publicRequest.get("/property");
      setProperty(res.data.data);
    } catch (error) {
      console.log(error);
    }
  };

  useEffect(() => {
    getProperty();
  }, []);

  return (
    <div className="pList container">
      {propterty
        ? propterty.map((p) => (
            <Link key={p.MaLoai} to={`/hotels?property=${p.MaLoai}`}>
              <div className="pListItem">
                <img src={p.Anh} alt="" className="pListImg" />
                <div className="pListTitle">{p.TenLoai}</div>
              </div>
            </Link>
          ))
        : null}
    </div>
  );
};

export default PropertyList;
