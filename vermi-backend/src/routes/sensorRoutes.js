const express = require('express');
const router = express.Router();
const sensorController = require('../controllers/sensorController');

router.get('/latest', sensorController.getLatestSensorData);
router.get('/history', sensorController.getSensorHistory);
router.post('/', sensorController.createSensorData);

module.exports = router;