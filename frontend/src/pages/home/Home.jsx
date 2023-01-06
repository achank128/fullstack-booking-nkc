import { useEffect, useState } from "react";
import "./home.scss";
import { publicRequest } from "../../request";
//components
import Featured from "../../components/featured/Featured";
import FeaturedProperties from "../../components/featuredProperties/FeaturedProperties";
import Footer from "../../components/footer/Footer";
import Header from "../../components/header/Header";
import LocationList from "../../components/locationList/LocationList";
import MailList from "../../components/mailList/MailList";
import Navbar from "../../components/navbar/Navbar";
import PropertyList from "../../components/propertyList/PropertyList";

const Home = () => {
  const [locations, setLocations] = useState([]);
  const [topHotels, setTopHotels] = useState([]);
  useEffect(() => {
    window.scrollTo(0, 0);
    const getLocation = async () => {
      try {
        const res = await publicRequest.get("/locations");
        setLocations(res.data.data);
      } catch (error) {
        console.log(error);
      }
    };
    const getHotelRating = async () => {
      try {
        const res = await publicRequest.get("/hotels/rating");
        setTopHotels(res.data.data);
      } catch (error) {
        console.log(error);
      }
    };
    getHotelRating();
    getLocation();
  }, []);
  return (
    <>
      <Navbar />
      <Header />

      <div className="homeContainer">
        <div className="homeTitle container">
          <h1>Nổi bật</h1>
        </div>
        {locations && <Featured locations={locations.slice(0, 3)} />}

        <div className="homeTitle container">
          <h1>Lên kế hoạch dễ dàng và nhanh chóng</h1>
          <h2>Khám phá các điểm đến hàng đầu theo cách bạn thích ở Việt Nam</h2>
        </div>
        {}
        {locations && <LocationList locations={locations.slice(0, 6)} />}

        <div className="homeTitle container">
          <h1>Tìm theo loại chỗ nghỉ</h1>
        </div>
        <PropertyList />
        <div className="homeTitle container">
          <h1>Nhà ở mà khách yêu thích</h1>
        </div>
        {topHotels && <FeaturedProperties topHotels={topHotels} />}
        <MailList />
      </div>
      <Footer />
    </>
  );
};

export default Home;
