import express from 'express';
import { getUsers } from '../controllers/userControllser.js';

const router = express.Router();

router.get('/', getUsers);

export default router;
