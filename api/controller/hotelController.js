import pool from "../db.js";
import sql from "mssql";

export const getHotels = async (req, res) => {
  const request = new sql.Request(pool);
  let q = "SELECT * FROM T_KhachSan";

  if (req.query.location) {
    request.input("maDiaDiem", req.query.location);
    q = "SELECT * FROM T_KhachSan WHERE MaDiaDiem = @maDiaDiem";
  } else if (req.query.property) {
    request.input("maLoai", req.query.property);
    q = "SELECT * FROM T_KhachSan WHERE MaLoai = @maLoai";
  } else if (req.query.search) {
    q = `
    SELECT MaKhachSan, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, DiaChi, 
    T_KhachSan.Anh AS Anh, MaLoai, MoTa, T_KhachSan.MaDiaDiem AS MaDiaDiem
    FROM T_KhachSan, T_DiaDiem 
    WHERE T_KhachSan.MaDiaDiem = T_DiaDiem.MaDiaDiem 
    AND (TenKhachSan LIKE N'%${req.query.search}%'
    OR TenDiaDiem LIKE N'%${req.query.search}%')`;
  }

  request.query(q, (err, result) => {
    if (err) {
      return res.status(400).json({ msg: "Error database", err });
    }
    res
      .status(200)
      .json({ data: result.recordset, count: result.rowsAffected[0] });
  });
};

export const getHotelbyID = async (req, res) => {
  const request = new sql.Request(pool);
  request.input("maKhachSan", req.params.id);
  let q = "SELECT * FROM T_KhachSan WHERE MaKhachSan = @maKhachSan";
  request.query(q, (err, result) => {
    if (err) {
      return res.status(400).json({ msg: "Error database", err });
    }
    res
      .status(200)
      .json({ data: result.recordset[0], count: result.rowsAffected[0] });
  });
};

export const getHotelbyLocationID = async (req, res) => {
  const request = new sql.Request(pool);
  request.input("maDiaDiem", req.params.lId);
  let q = "SELECT * FROM T_KhachSan WHERE MaDiaDiem = @maDiaDiem";
  request.query(q, (err, result) => {
    if (err) {
      return res.status(400).json({ msg: "Error database", err });
    }
    res
      .status(200)
      .json({ data: result.recordset, count: result.rowsAffected[0] });
  });
};

export const getHotelService = async (req, res) => {
  const request = new sql.Request(pool);
  request.input("maKhachSan", req.params.sId);
  let q = `
    SELECT T_DichVu.MaDichVu AS MaDichVu, TenDichVu from T_DichVu, T_DSDichVu 
    WHERE T_DichVu.MaDichVu = T_DSDichVu.MaDichVu 
    AND MaKhachSan = @maKhachSan
  `;
  request.query(q, (err, result) => {
    if (err) {
      return res.status(400).json({ msg: "Error database", err });
    }
    res
      .status(200)
      .json({ data: result.recordset, count: result.rowsAffected[0] });
  });
};

export const getHotelTypeRoom = async (req, res) => {
  const request = new sql.Request(pool);
  request.input("maKhachSan", req.params.rId);
  let q = "SELECT * FROM T_LoaiPhong WHERE MaKhachSan = @maKhachSan";
  request.query(q, (err, result) => {
    if (err) {
      return res.status(400).json({ msg: "Error database", err });
    }
    res
      .status(200)
      .json({ data: result.recordset, count: result.rowsAffected[0] });
  });
};

export const getHotelRating = async (req, res) => {
  const request = new sql.Request(pool);
  request.input("maKhachSan", req.params.rId);
  let q = "SELECT TOP 4 * FROM T_KhachSan ORDER BY DanhGia DESC";
  request.query(q, (err, result) => {
    if (err) {
      return res.status(400).json({ msg: "Error database", err });
    }
    res
      .status(200)
      .json({ data: result.recordset, count: result.rowsAffected[0] });
  });
};
