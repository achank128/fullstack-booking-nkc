import sql from "mssql";

const sqlConfig = {
  user: "sa",
  password: "123456789",
  database: "BookingManagement",
  server: "localhost",
  options: {
    encrypt: true,
    trustServerCertificate: true,
  },
};

const pool = new sql.ConnectionPool(sqlConfig);
pool.connect();

export default pool;

// const connectDb = async () => {
//   try {
//     await sql.connect(sqlConfig);
//     console.log("Connected Microsoft SQL Server!");
//     const result = await sql.query`select top 10 * from T_Phong`;
//     console.dir(result.recordset);
//   } catch (err) {
//     console.log(err);
//   }
// };
// connectDb();
