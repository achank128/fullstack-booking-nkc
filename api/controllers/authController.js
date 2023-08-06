import pool from "../db.js";
import sql from "mssql";

export const register = async (req, res) => {
  const request = new sql.Request(pool);
  const { username, password, email, name, phone } = req.body;

  let q =
    "SELECT * FROM T_TaiKhoan WHERE TenDangNhap = @username OR Email = @email";
  request.input("username", username);
  request.input("email", email);

  request.query(q, (err, result) => {
    if (err) {
      return res.status(400).json({ msg: "Error database 1", err });
    }

    if (result.recordset.length > 0) {
      return res.status(400).json({ msg: "Email or Username already exist!" });
    }

    let q2 =
      "INSERT INTO T_TaiKhoan(TenDangNhap, MatKhau, Email, HoTen, SDT) VALUES (@username, @password, @email, @name, @phone)";
    request.input("password", password);
    request.input("name", name);
    request.input("phone", phone);

    request.query(q2, (err, result) => {
      if (err) {
        return res.status(400).json({ msg: "Error database 2", err });
      }

      let q3 = "SELECT * FROM T_TaiKhoan WHERE TenDangNhap = @username";
      request.query(q3, (err, result) => {
        if (err) {
          return res.status(400).json({ msg: "Error database 3", err });
        }

        res.status(200).json({
          msg: "User has been created!",
          data: result.recordset[0],
        });
      });
    });
  });
};

export const login = async (req, res) => {
  const request = new sql.Request(pool);
  const { username, password } = req.body;
  let q = "SELECT * FROM T_TaiKhoan WHERE TenDangNhap = @username";
  request.input("username", username);

  request.query(q, (err, result) => {
    if (err) {
      return res.status(400).json({ msg: "Truy van bi loi", err });
    }
    if (!result.recordset[0]) {
      return res.status(400).json({
        msg: "Username do not exist",
      });
    } else {
      if (result.recordset[0].MatKhau === password) {
        return res
          .status(200)
          .json({ msg: "Login successfully!", data: result.recordset[0] });
      } else {
        return res.status(400).json({ msg: "Incorrect password" });
      }
    }
  });
};
