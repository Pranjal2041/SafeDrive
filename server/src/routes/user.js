/* eslint-disable import/named */
import express from 'express';
import bcrypt from 'bcryptjs';
import { createJWTtoken, verifyToken, computeRepairCost } from '../utils/utils';
import { User, Crash } from '../models/user';

const router = express.Router();

router.post('/login', async (req, res) => {
    try {
        const { email, password } = req.body;
        // try to find the user in the database
        const user = await User.findOne({ email });
        // this means user doesn't exists, so throw an error TODO: add correct status to return
        if (!user) {
            return res.status(401).json({
                message: 'Not a registered email address',
                error: true,
            });
        }

        // Compare passwords
        const isMatch = await bcrypt.compare(password, user.password);

        // Incorrect password
        if (!isMatch) {
            return res.status(401).json({
                message: 'Password seems to be incorrect',
                error: true,
            });
        }

        const token = createJWTtoken(user);

        return res.status(200).json({
            error: false,
            message: 'Logged in successfully',
            role: user.role,
            token,
        });
    } catch (err) {
        console.log(err);
        res.send(500).json({
            message: 'WHOOPS!! A server error occured, please try again later',
            error: true,
        });
    }
});

router.post('/reportCrash', async (req, res) => {
    const { damagedParts } = req.body;
    const user = await verifyToken(req);
    const repairCost = computeRepairCost(damagedParts);
    try {
        const existingCrash = await Crash.findOne({ user });
        if (!existingCrash) {
            await Crash.create({
                user,
                damagedParts,
                repairCost,
            });
        } else {
            existingCrash.damagedParts = damagedParts;
            existingCrash.repairCost = repairCost;
            await existingCrash.save();
        }
        return res.status(200).json({
            err: false,
            msg: 'Crash reported successfully',
        });
    } catch (error) {
        return res.status(500).json({
            err: true,
            msg: 'A server error occured',
        });
    }
});

router.post('/register', async (req, res) => {
    const { firstname, lastname, username, email, password } = req.body;

    try {
        // try to find the user in the database
        let user = await User.findOne({ email });

        // User already exists
        if (user) {
            return res.status(400).json({
                message: 'User already exists with same email',
                error: true,
            });
        }

        if (await User.findOne({ username })) {
            return res.status(400).json({
                message: 'A user already exists with same username',
                error: true,
            });
        }

        // Create a new user of type `User`
        user = new User({
            firstname,
            lastname,
            username,
            email,
            password,
        });

        // encrypt the password using bcrypt
        const salt = await bcrypt.genSalt(10); // which to use 10 or more than that

        // update the password to encrypted one
        user.password = await bcrypt.hash(user.password, salt);

        // Save the updated the user in database
        await user.save();
        return res.sendStatus(200);
    } catch (err) {
        console.log(err);
        res.send(500).json({
            message: 'WHOOPS!! A server error occured, please try again later',
            error: true,
        });
    }
});

export default router;
