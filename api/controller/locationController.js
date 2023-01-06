import pool from "../db.js";
import sql from "mssql";

export const getLocations = async (req, res) => {
  const request = new sql.Request(pool);
  let q = "SELECT * FROM T_DiaDiem";
  if (req.query.q) {
    request.input("loaiDiaDiem", req.query.q);
    q = "SELECT * FROM T_DiaDiem WHERE LoaiDiaDiem = @loaiDiaDiem";
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
