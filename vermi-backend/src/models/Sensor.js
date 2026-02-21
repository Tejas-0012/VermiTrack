const mongoose = require('mongoose');

const sensorSchema = new mongoose.Schema({
  temperature: { type: Number, required: true },
  moisture: { type: Number, required: true },
  ph: { type: Number, required: true },
  healthStatus: { 
    type: String, 
    enum: ['Healthy', 'Warning', 'Critical'],
    default: 'Healthy'
  },
  compostDay: { type: Number, default: 1 },
  deviceId: { type: String, default: 'ESP32_001' },
  timestamp: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Sensor', sensorSchema);