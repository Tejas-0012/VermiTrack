const mongoose = require('mongoose');

const compostSchema = new mongoose.Schema({
  bedId: { type: String, required: true },
  compostAge: { type: Number, default: 1 },
  totalDays: { type: Number, default: 45 },
  currentPhase: { 
    type: String, 
    enum: ['Setup', 'Active', 'Maturation', 'Harvest'],
    default: 'Setup'
  },
  healthScore: { type: Number, default: 85 },
  wormCount: { type: Number, default: 500 },
  bedSize: { type: String, default: 'Medium' },
  lastFed: { type: Date, default: Date.now },
  lastWatered: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Compost', compostSchema);