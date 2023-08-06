import { Link } from "react-router-dom";
import "./mailList.scss";

const MailList = () => {
  return (
    <div className="mail">
      <h2 className="mailTitle">Tiết kiệm thời gian và tiền bạc!</h2>
      <span className="mailDesc">
        Hãy đăng ký và chúng tôi sẽ gửi những ưu đãi tốt nhất cho bạn
      </span>
      <div className="mailInputContainer">
        <input type="text" placeholder="Địa chỉ Email của bạn" />
        <Link to="/register">
          <button>Đăng ký</button>
        </Link>
      </div>
    </div>
  );
};

export default MailList;
