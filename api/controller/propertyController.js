import pool from "../db.js";
import sql from "mssql";

export const getProperty = async (req, res) => {
  const request = new sql.Request(pool);
  let q = "SELECT * FROM T_Loai";

  request.query(q, (err, result) => {
    if (err) {
      return res.status(400).json({ msg: "Error database", err });
    }
    res
      .status(200)
      .json({ data: result.recordset, count: result.rowsAffected[0] });
  });
};
