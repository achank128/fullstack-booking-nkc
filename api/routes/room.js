import express from 'express';
import {
  bookRoom,
  getBooked,
  getRoomById,
  getRoomsAvaiable,
} from '../controllers/roomController.js';

const router = express.Router();

router.get('/:id', getRoomById);
router.post('/avaiable', getRoomsAvaiable);
router.post('/book', bookRoom);
router.get('/booked/:id', getBooked);

export default router;
