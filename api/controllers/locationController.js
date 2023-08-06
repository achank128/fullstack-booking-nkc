import pool from '../db.js'
import sql from 'mssql'

export const getLocations = async (req, res) => {
  const request = new sql.Request(pool)

  const limit = req.query.limit ? Number(req.query.limit) : 10
  const offset = req.query.offset ? Number(req.query.offset) : 0
  let q = `SELECT * FROM T_DiaDiem ORDER BY MaDiaDiem OFFSET ${offset} ROWS FETCH NEXT ${limit} ROWS ONLY`

  if (req.query.q) {
    request.input('loaiDiaDiem', req.query.q)
    q = 'SELECT * FROM T_DiaDiem WHERE LoaiDiaDiem = @loaiDiaDiem'
  }
  request.query(q, (err, result) => {
    if (err) {
      return res.status(400).json({ msg: 'Error database', err })
    }
    request.query(
      'SELECT COUNT(MaDiaDiem) AS total FROM T_DiaDiem',
      (err, resTotal) => {
        const total = resTotal.recordset[0].total
        res.status(200).json({
          meta: { count: result.rowsAffected[0], limit, offset, total },
          data: result.recordset,
        })
      }
    )
  })
}
