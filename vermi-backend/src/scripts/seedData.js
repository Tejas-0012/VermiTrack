const mongoose = require('mongoose');
const connectDB = require('../config/db');
const Sensor = require('../models/Sensor');
require('dotenv').config();

// Sample sensor data for last 5 days
const seedData = [
  {
    temperature: 28.5,
    moisture: 65.2,
    ph: 7.2,
    healthStatus: 'Healthy',
    compostDay: 15,
    deviceId: 'ESP32_001',
    timestamp: new Date(Date.now() - 0 * 24 * 60 * 60 * 1000) // Today
  },
  {
    temperature: 29.1,
    moisture: 63.8,
    ph: 7.1,
    healthStatus: 'Healthy',
    compostDay: 14,
    deviceId: 'ESP32_001',
    timestamp: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000) // Yesterday
  },
  {
    temperature: 30.2,
    moisture: 58.5,
    ph: 7.0,
    healthStatus: 'Warning',
    compostDay: 13,
    deviceId: 'ESP32_001',
    timestamp: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000) // 2 days ago
  },
  {
    temperature: 27.8,
    moisture: 67.3,
    ph: 7.3,
    healthStatus: 'Healthy',
    compostDay: 12,
    deviceId: 'ESP32_001',
    timestamp: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000) // 3 days ago
  },
  {
    temperature: 26.5,
    moisture: 70.1,
    ph: 7.4,
    healthStatus: 'Warning',
    compostDay: 11,
    deviceId: 'ESP32_001',
    timestamp: new Date(Date.now() - 4 * 24 * 60 * 60 * 1000) // 4 days ago
  }
];

const seedDatabase = async () => {
  try {
    // Connect to MongoDB
    await connectDB();
    console.log('📦 Connected to MongoDB');

    // Clear existing data (optional - remove if you want to keep existing)
    await Sensor.deleteMany({});
    console.log('🗑️  Cleared existing sensor data');

    // Insert seed data
    const inserted = await Sensor.insertMany(seedData);
    console.log(`✅ Inserted ${inserted.length} sensor records`);

    // Display inserted data
    console.log('\n📊 Inserted Data:');
    inserted.forEach((doc, index) => {
      console.log(`\n[${index + 1}] Day ${doc.compostDay}:`);
      console.log(`   🌡️  Temp: ${doc.temperature}°C`);
      console.log(`   💧 Moisture: ${doc.moisture}%`);
      console.log(`   🧪 pH: ${doc.ph}`);
      console.log(`   ❤️  Health: ${doc.healthStatus}`);
      console.log(`   🕒 ${doc.timestamp.toLocaleDateString()}`);
    });

    // Disconnect
    await mongoose.disconnect();
    console.log('\n👋 Disconnected from MongoDB');
    
  } catch (error) {
    console.error('❌ Error seeding database:', error);
    process.exit(1);
  }
};

// Run seeder
seedDatabase();