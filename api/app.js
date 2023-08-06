import express from 'express';
import cors from 'cors';
//Routes
import authRoute from './routes/auth.js';
import hotelRoute from './routes/hotel.js';
import locationRoute from './routes/location.js';
import propertyRoute from './routes/property.js';
import roomRoute from './routes/room.js';
import userRoute from './routes/user.js';

const app = express();

app.use(express.json());
app.use(cors());

app.use('/api/hotels', hotelRoute);
app.use('/api/auth', authRoute);
app.use('/api/property', propertyRoute);
app.use('/api/locations', locationRoute);
app.use('/api/rooms', roomRoute);
app.use('/api/users', userRoute);

app.get('/', (req, res) => {
  res.send('Booking Management API!');
});

app.listen(5000, () => {
  console.log('Server is listening on port: http://localhost:5000/');
});
