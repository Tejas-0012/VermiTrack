const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

// Import database connection
const connectDB = require('./config/db');

// Import routes
const sensorRoutes = require('./routes/sensorRoutes');
const compostRoutes = require('./routes/compostRoutes');
// const authRoutes = require('./routes/authRoutes');

const app = express();

// Connect to MongoDB Atlas
connectDB();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
// app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Routes
app.use('/api/sensors', sensorRoutes);
app.use('/api/compost', compostRoutes);
// app.use('/api/auth', authRoutes);

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date() });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, '0.0.0.0',() => {
   console.log(`🚀 Server running on port ${PORT} with Socket.IO`);
  console.log(`📍 Local: http://localhost:${PORT}`);
});