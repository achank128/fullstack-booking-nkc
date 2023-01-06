import express from "express";
import { getLocations } from "../controller/locationController.js";

const router = express.Router();

router.get("/", getLocations);

export default router;
