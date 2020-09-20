/* eslint-disable no-await-in-loop */
/* eslint-disable no-undef */
/* eslint-disable no-restricted-syntax */
import express from 'express';
// import { verifyToken } from '../utils/utils';
import {
    dictionary,
    states_hash,
    categoryIDs,
    crashData,
    crashData1,
    deathRate,
} from '../config/keys';
import {
    getCrashDistance,
    verifyToken,
    convertEpoch,
    getNetForce,
    legalAdvisor,
    geoDecode,
    getState,
    computeAltitudes,
    carMD,
} from '../utils/utils';
import { Crash } from '../models/user';

const router = express.Router();
const axios = require('axios');

const URL = 'https://api.foursquare.com/v2/venues/search';
// router.use(async (req, res, next) => {
//     try {
//         const user = await verifyToken(req);
//         req.user = user;
//         next();
//     } catch (error) {
//         console.log(error);
//         return res.status(401).json({
//             message: 'Invalid Token',
//             error: true,
//         });
//     }
// });

router.post('/sendSms', async (req, res) => {
    try {
        const user = await verifyToken(req);
        // eslint-disable-next-line global-require
        const twilio = require('twilio')(
            process.env.TWILIO_SID,
            process.env.TWILIO_SECRET
        );
        // const { phoneNums } = req.body;
        const phoneNums = [
            '+918860851650',
            '+919560621100',
            '+917017538459',
            '+918826858995',
        ];
        const address = await geoDecode(
            crashData.crash_lat,
            crashData.crash_lng
        );
        if (!phoneNums) {
            return res.status(400).json({
                err: true,
                msg: 'No phone numbers found',
            });
        }
        for (let i = 0; i < phoneNums.length; i += 1) {
            const num = phoneNums[i];
            try {
                const coord = encodeURI(
                    `https://maps.google.com/maps?q=${crashData.crash_lat},${crashData.crash_lng}`
                );
                await twilio.messages.create({
                    from: process.env.TWILIO_NUM,
                    to: num,
                    body: `Your friend ${user.firstname} ${user.lastname} has encountered an unfortunate crash with severity: ${crashData.severity}. The last location recorded was ${address}. Directions: ${coord} Your friend needs your urgent help!`,
                });
                // eslint-disable-next-line no-empty
            } catch (error) {}
        }
        return res.status(200).json({
            err: false,
            msg: 'Messages sent successfully',
        });
    } catch (error) {
        return res.sendStatus(500);
    }
});

router.get('/dictionary', (req, res) => {
    return res.status(200).json(dictionary);
});

router.get('/details', async (req, res) => {
    try {
        const user = await verifyToken(req);

        const lat = crashData.crash_lat;
        const long = crashData.crash_lng;
        const address = await geoDecode(lat, long);
        let time = new Date(crashData.main_impact_time);
        time = `${time.toLocaleTimeString()}, ${time.toDateString()}`;

        const crash = await Crash.findOne({
            user,
        });
        let damagedParts;
        let repairCost;
        if (!crash) {
            damagedParts = ['Unknown'];
            repairCost = 0;
        } else {
            damagedParts = crash.damagedParts;
            repairCost = crash.repairCost;
        }

        return res.status(200).json({
            lat,
            long,
            address,
            time,
            driver_direction: crashData.driver_direction,
            damagedParts,
            repairCost,
            narrative: crashData.narrative,
        });
    } catch (error) {
        return res.sendStatus(500);
    }
});

router.get('/weather', (req, res) => {
    const { weather } = crashData;
    if (!weather) {
        return res.status(400).json({
            err: true,
            msg: 'Weather Data not found',
        });
    }
    const response = {
        text: weather.weather_text,
        temperature: weather.temperature,
        wind_direction: weather.wind_direction_text,
        wind_speed: weather.wind_gust_speed,
        visibility: weather.visibility,
        precipitation: weather.precipitation_type,
        day_time: weather.is_day_time,
        facing_sun: weather.driver_facing_sun,
    };

    const crashDist = getCrashDistance();
    let analysis = '';
    if (crashDist > weather.visibility) {
        analysis = `The estimated crash distance ${crashDist} km is greater than the visibility ${response.visibility} km at that time. This shows that weather conditions could be a cause of the accident. `;
    } else {
        analysis = `The estimated crash distance ${crashDist} km is less than the visibility ${response.visibility} km at that time. This shows that weather conditions were not likely a cause of the accident. `;
    }
    if (response.day_time) {
        analysis += 'The accident occured during the day';
        if (response.facing_sun)
            analysis += ' and the driver was facing the sun.';
    } else {
        analysis += 'The accident occured during the night.';
    }
    response.analysis = analysis;

    return res.status(200).json({
        response,
    });
});

router.get('/damages', (req, res) => {
    const analysis = `The car was hit from ${
        crashData.hit_direction
    } experiencing a damage of ${crashData.front_hit} %, ${
        crashData.rear_hit
    } % , ${crashData.left_hit} % , ${
        crashData.right_hit
    } % from front, rear, left, right respectively. The impact was ${
        crashData.severity > 50 ? 'very' : 'not'
    } severe. The car ${
        crashData.rollover ? 'rolled over' : 'did not roll over'
    }. The vehicle was hit ${crashData.num_impacts} times.`;
    return res.status(200).json({
        hit_direction: crashData.hit_direction,
        front_hit: crashData.front_hit,
        rear_hit: crashData.rear_hit,
        left_hit: crashData.left_hit,
        right_hit: crashData.right_hit,
        severity: crashData.severity,
        rollover: crashData.rollover,
        vehicle_spin: crashData.vehicle_spin,
        num_impacts: crashData.num_impacts,
        analysis,
    });
});

router.get('/altitude', async (req, res) => {
    const {
        before_coords,
        after_coords,
        crash_lat,
        crash_lng,
        main_impact_time,
    } = crashData1;
    const query = [];
    if (before_coords.length !== 0) {
        query.push(before_coords[0]);
        query.push(before_coords[before_coords.length - 1]);
    }
    query.push({
        lat: crash_lat,
        lng: crash_lng,
        time: main_impact_time,
    });
    if (after_coords.length !== 0) {
        query.push(after_coords[0]);
        query.push(after_coords[after_coords.length - 1]);
    }
    try {
        const response = await computeAltitudes(query);
        return res.status(200).json(response);
    } catch (error) {
        console.log(error);
        return res.sendStatus(500);
    }
});

router.get('/kinematics', (req, res) => {
    let speed_curve = crashData.gps_speed;
    let minEpoch = Infinity;
    speed_curve.forEach((e) => {
        minEpoch = Math.min(minEpoch, e.x);
    });
    speed_curve = convertEpoch(speed_curve, minEpoch);
    const accel_lat = convertEpoch(crashData.accel_lat_data, minEpoch);
    const accel_lon = convertEpoch(crashData.accel_lon_data, minEpoch);
    const accel_vert = convertEpoch(crashData.accel_vert_data, minEpoch);

    const force = getNetForce(accel_lat, accel_lon, accel_vert);
    return res.status(200).json({
        speed_curve,
        accel_lat,
        accel_lon,
        accel_vert,
        force,
        start_time: crashData.start_time - minEpoch,
        stop_time: crashData.end_time - minEpoch,
        impact_time: crashData.main_impact_time - minEpoch,
        impact_speed: crashData.impact_speed,
    });
});

router.get('/legalities', (req, res) => {
    const response = legalAdvisor();
    return res.status(200).json(response);
});

router.get('/stateStats', (req, res) => {
    // eslint-disable-next-line prefer-const
    let response = {};
    const states = Object.values(states_hash);
    states.forEach((state) => {
        response[state] = {
            Deaths: Math.floor(Math.random() * 20),
            'Severe Accidents': Math.floor(Math.random() * 5),
            Accident: Math.floor(Math.random() * 200),
        };
    });
    return res.status(200).json(response);
});

router.get('/coordsToName', async (req, res) => {
    const { lat, long } = req.query;
    if (!lat) {
        return res.status(400).json({
            err: true,
            msg: 'Latitude not supplied in query parameters',
        });
    }
    if (!long) {
        return res.status(400).json({
            err: true,
            msg: 'Longitude not supplied in query parameters',
        });
    }
    try {
        const address = await geoDecode(lat, long);
        return res.status(200).json({
            address,
        });
    } catch (error) {
        console.log(error);
        return res.sendStatus(500);
    }
});
router.get('/deathRate', async (req, res) => {
    const { lat, long } = req.query;
    if (!lat) {
        return res.status(400).json({
            err: true,
            msg: 'Latitude not supplied in query parameters',
        });
    }
    if (!long) {
        return res.status(400).json({
            err: true,
            msg: 'Longitude not supplied in query parameters',
        });
    }
    try {
        const state = await getState(lat, long);
        console.log(state);
        if (Object.keys(deathRate).includes(state)) {
            return res.status(200).json({
                deathRate: (100.0 - deathRate[state]).toFixed(2),
            });
        }
        return res.status(404).json({
            err: true,
            msg: 'Death Rate could not be found',
        });
    } catch (error) {
        console.log(error);
        return res.sendStatus(500);
    }
});

router.get('/nearbyHospitals', async (req, res) => {
    const { lat, long } = req.query;
    let { count } = req.query;
    if (!lat) {
        return res.status(400).json({
            err: true,
            msg: 'Latitude not supplied in query parameters',
        });
    }
    if (!long) {
        return res.status(400).json({
            err: true,
            msg: 'Longitude not supplied in query parameters',
        });
    }
    if (!count) {
        count = 10;
    }
    try {
        const apiResponse = await axios.get(
            `${URL}?v=20200919&client_id=${process.env.CLIENT_ID}&client_secret=${process.env.CLIENT_SECRET}&ll=${lat},${long}&limit=${count}&categoryId=${categoryIDs.hospital}`
        );
        if (apiResponse.status !== 200) {
            return res.status(400).json({
                msg: 'No nearby hospital found',
                err: true,
            });
        }
        const { venues } = apiResponse.data.response;
        const hospitals = [];
        venues.forEach((venue) => {
            hospitals.push({
                name: venue.name,
                lat: venue.location.lat,
                long: venue.location.lng,
                address: venue.location.formattedAddress.join(', '),
            });
        });
        return res.status(200).json(hospitals);
    } catch (error) {
        console.log(error);
        return res.sendStatus(500);
    }
});
router.get('/nearbyRepair', async (req, res) => {
    const { lat, long } = req.query;
    let { count } = req.query;
    if (!lat) {
        return res.status(400).json({
            err: true,
            msg: 'Latitude not supplied in query parameters',
        });
    }
    if (!long) {
        return res.status(400).json({
            err: true,
            msg: 'Longitude not supplied in query parameters',
        });
    }
    if (!count) {
        count = 10;
    }
    try {
        const apiResponse = await axios.get(
            `${URL}?v=20200919&client_id=${process.env.CLIENT_ID}&client_secret=${process.env.CLIENT_SECRET}&ll=${lat},${long}&limit=${count}&categoryId=${categoryIDs.repair}`
        );
        if (apiResponse.status !== 200) {
            return res.status(400).json({
                msg: 'No nearby repair shops found',
                err: true,
            });
        }
        const { venues } = apiResponse.data.response;
        const repairShops = [];
        venues.forEach((venue) => {
            repairShops.push({
                name: venue.name,
                lat: venue.location.lat,
                long: venue.location.lng,
                address: venue.location.formattedAddress.join(', '),
            });
        });
        return res.status(200).json(repairShops);
    } catch (error) {
        console.log(error);
        return res.sendStatus(500);
    }
});

router.post('/repair', async (req, res) => {
    const { vin, mileage, dtc } = req.body;
    try {
        const response = carMD(vin, mileage, dtc);
        return res.status(200).json(response);
    } catch (error) {
        return res.sendStatus(500);
    }
});
export default router;
