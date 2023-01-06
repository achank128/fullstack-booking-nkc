import React, { useEffect, useState } from "react";
import "./listHotel.scss";
import Navbar from "../../components/navbar/Navbar";
import Header from "../../components/header/Header";
import HotelItem from "../../components/hotelItem/HotelItem";
import ListSearch from "../../components/listSearch/ListSearch";
import { useLocation } from "react-router-dom";
import { publicRequest } from "../../request";
import MailList from "../../components/mailList/MailList";
import Footer from "../../components/footer/Footer";

const List = () => {
  const { search: query } = useLocation();
  const [hotels, setHotels] = useState([]);

  useEffect(() => {
    window.scrollTo(0, 0);
    const getHotels = async () => {
      try {
        const res = await publicRequest.get("/hotels" + query);
        setHotels(res.data.data);
      } catch (error) {
        console.log(error);
      }
    };
    getHotels();
  }, [query]);

  return (
    <>
      <Navbar />
      <Header type="list" />
      <div className="listContainer">
        <div className="listWrapper">
          <ListSearch />
          <div className="listResult">
            <div className="titleResult">
              <h2>Tìm thấy {hotels?.length} chỗ nghỉ</h2>
              <button>Sắp xếp theo lựa chọn hàng đầu của chúng tôi</button>
            </div>
            {hotels
              ? hotels.map((hotel) => (
                  <HotelItem hotel={hotel} key={hotel.MaKhachSan} />
                ))
              : null}
          </div>
        </div>
      </div>
      <MailList />
      <Footer />
    </>
  );
};

export default List;
