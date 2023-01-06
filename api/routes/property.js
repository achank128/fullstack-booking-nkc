import express from "express";
import { getProperty } from "../controller/propertyController.js";

const router = express.Router();

router.get("/", getProperty);

export default router;
