import pool from "../db.js";
import sql from "mssql";

export const getRoomById = async (req, res) => {
  const request = new sql.Request(pool);
  request.input("maLoai", req.params.id);
  let q = "SELECT * FROM V_LoaiPhongKS WHERE MaLoaiPhong = @maLoai";
  request.query(q, (err, result) => {
    if (err) {
      return res.status(400).json({ msg: "Error database", err });
    }
    res.status(200).json({ data: result.recordset[0] });
  });
};

export const getRoomsAvaiable = async (req, res) => {
  const request = new sql.Request(pool);
  const { typeId, checkIn, checkOut } = req.body;
  request.input("maLoai", sql.Int, typeId);
  request.input("checkin", sql.Date, checkIn);
  request.input("checkout", sql.Date, checkOut);

  try {
    const result = await request.execute("S_PhongTrong");
    res
      .status(200)
      .json({ data: result.recordset, count: result.rowsAffected[0] });
  } catch (error) {
    res.status(400).json({ msg: "Error database", error });
  }
};

export const bookRoom = async (req, res) => {
  const request = new sql.Request(pool);
  const { typeId, userId, checkIn, checkOut } = req.body;
  request.input("maLoai", typeId);
  request.input("maTaiKhoan", userId);
  request.input("checkin", checkIn);
  request.input("checkout", checkOut);
  try {
    await request.execute("S_DatPhong");
    res.status(200).json({ msg: "Book room successful" });
  } catch (error) {
    res.status(400).json({ msg: "Error database", error });
  }
};

export const getBooked = async (req, res) => {
  const request = new sql.Request(pool);
  request.input("maTaiKhoan", req.params.id);
  let q =
    "SELECT * FROM V_DonDatPhongKS WHERE MaTaiKhoan = @maTaiKhoan ORDER BY MaDat DESC";
  request.query(q, (err, result) => {
    if (err) {
      return res.status(400).json({ msg: "Error database", err });
    }
    res
      .status(200)
      .json({ data: result.recordset, count: result.rowsAffected[0] });
  });
};
