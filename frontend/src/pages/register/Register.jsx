import { useState } from "react";
import { useNavigate } from "react-router-dom";
import Navbar from "../../components/navbar/Navbar";
import { publicRequest } from "../../request";
import "./register.scss";

const Register = () => {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [email, setEmail] = useState("");
  const [name, setName] = useState("");
  const [phone, setPhone] = useState("");
  const navigate = useNavigate();

  const handleRegister = async (e) => {
    e.preventDefault();
    try {
      const res = await publicRequest.post("/auth/register", {
        username,
        password,
        email,
        name,
        phone,
      });
      localStorage.setItem("user", JSON.stringify(res.data.data));
      navigate("/");
    } catch (error) {
      console.log(error);
    }
  };

  return (
    <>
      <Navbar />
      <div className="register">
        <div className="container">
          <h3 style={{ textAlign: "center" }}>Đăng Ký</h3>
          <form className="form">
            <label htmlFor="email">Email:</label>
            <input
              type="email"
              placeholder="Email"
              id="email"
              className="input"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            />

            <label htmlFor="name">Tên đầy đủ:</label>
            <input
              type="text"
              placeholder="Full Name"
              id="name"
              className="input"
              value={name}
              onChange={(e) => setName(e.target.value)}
            />

            <label htmlFor="phone">Số điện thoại:</label>
            <input
              type="text"
              placeholder="Phone number"
              id="phone"
              className="input"
              value={phone}
              onChange={(e) => setPhone(e.target.value)}
            />

            <label htmlFor="username">Tên đăng nhập:</label>
            <input
              type="text"
              placeholder="Username"
              id="username"
              className="input"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
            />

            <label htmlFor="pasword">Mật khẩu:</label>
            <input
              type="password"
              placeholder="Password"
              id="password"
              className="input"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
            <button className="button" onClick={handleRegister}>
              Register
            </button>
          </form>

          <p>Bảo lưu mọi quyền. </p>
          <p>Bản quyền (2006 - 2022) - Booking.com™</p>
        </div>
      </div>
    </>
  );
};

export default Register;
