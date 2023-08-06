import express from 'express';
import {
  getHotelbyID,
  getHotelRating,
  getHotels,
  getHotelService,
  getHotelTypeRoom,
} from '../controllers/hotelController.js';

const router = express.Router();

router.get('/', getHotels);
router.get('/rating', getHotelRating);
router.get('/:id', getHotelbyID);
router.get('/room/:rId', getHotelTypeRoom);
router.get('/service/:sId', getHotelService);

export default router;
