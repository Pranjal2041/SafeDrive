// User Model Schema

// Import mongoose

const mongoose = require('mongoose');

const userSchema = mongoose.Schema({
    username: {
        type: String,
        // required: true,
        minlength: 6,
        maxlength: 30,
    },
    firstname: {
        type: String,
        maxlength: 30,
    },
    lastname: {
        type: String,
        maxlength: 30,
    },
    password: {
        type: String,
        required: true,
    },
    email: {
        type: String,
        required: true,
        unique: true,
    },
    role: {
        type: String,
        enum: ['driver', 'insurance'],
    },
});

const CrashSchema = mongoose.Schema({
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
    },
    damagedParts: {
        type: [String],
    },
    repairCost: {
        type: Number,
    },
});

module.exports = {
    User: mongoose.model('User', userSchema),
    Crash: mongoose.model('Crash', CrashSchema),
};
