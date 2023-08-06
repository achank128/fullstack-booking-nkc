import { useState } from "react";
import { useNavigate } from "react-router-dom";
import Navbar from "../../components/navbar/Navbar";
import { publicRequest } from "../../request";
import "./login.scss";

const Login = () => {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const navigate = useNavigate();

  const handleLogin = async (e) => {
    e.preventDefault();
    try {
      const res = await publicRequest.post("/auth/login", {
        username,
        password,
      });
      localStorage.setItem("user", JSON.stringify(res.data.data));
      navigate("/");
    } catch (error) {
      setError("Username or Password không chính xác");
      console.log(error);
    }
  };

  return (
    <>
      <Navbar />
      <div className="login">
        <div className="container">
          <h3 style={{ textAlign: "center" }}>Đăng Nhập</h3>
          <form className="form">
            <label htmlFor="username">Username:</label>
            <input
              type="text"
              placeholder="username"
              id="username"
              className="input"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
            />
            <label htmlFor="pasword">Password:</label>
            <input
              type="password"
              placeholder="password"
              id="password"
              className="input"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
            <p className="error">{error}</p>

            <button className="button" onClick={handleLogin}>
              Login
            </button>
          </form>

          <p>Bảo lưu mọi quyền. </p>
          <p>Bản quyền (2006 - 2022) - Booking.com™</p>
        </div>
      </div>
    </>
  );
};

export default Login;
