const Sensor = require('../models/Sensor');

// Get latest sensor data
exports.getLatestSensorData = async (req, res) => {
  try {
    const data = await Sensor.findOne().sort({ timestamp: -1 });
    res.json(data);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get sensor history
exports.getSensorHistory = async (req, res) => {
  try {
    const { startDate, endDate, limit = 100 } = req.query;
    let query = {};
    
    if (startDate || endDate) {
      query.timestamp = {};
      if (startDate) query.timestamp.$gte = new Date(startDate);
      if (endDate) query.timestamp.$lte = new Date(endDate);
    }
    
    const data = await Sensor.find(query)
      .sort({ timestamp: -1 })
      .limit(parseInt(limit));
    
    res.json(data);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Create new sensor reading
exports.createSensorData = async (req, res) => {
  try {
    const sensorData = new Sensor(req.body);
    await sensorData.save();
    res.status(201).json(sensorData);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};