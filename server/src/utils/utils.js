/* eslint-disable no-unused-vars */
/* eslint-disable no-shadow */
/* eslint-disable no-restricted-syntax */
/* eslint-disable no-await-in-loop */
/* eslint-disable import/named */
/* eslint-disable no-param-reassign */
import jwt, { verify } from 'jsonwebtoken';
import * as keys from '../config/keys';
import { User } from '../models/user';

const createJWTtoken = (user, res, tokenName = keys.accessTokenName) => {
    const payload = {
        user: {
            id: user.id,
            email: user.email,
            firstname: user.firstname,
            lastname: user.lastname,
            username: user.username,
            role: user.role,
        },
    };
    const exp =
        tokenName === keys.refreshTokenName ? keys.rememberTime : keys.expTime;
    // create a token
    const token = jwt.sign(payload, keys.privateKey, {
        expiresIn: exp, // in seconds
        issuer: keys.iss,
        algorithm: 'RS256',
    });

    return token;
};

const verifyToken = async (req) => {
    const { token } = req.query;

    const decoded = verify(token, keys.publicKey, {
        algorithms: ['RS256'],
    });
    const user = await User.findById(decoded.user.id);

    return user;
};

const axios = require('axios');

const URL = 'https://api.foursquare.com/v2/venues/search';
const ElevationAPI = 'https://api.airmap.com/elevation/v1/ele/path';

const computeAltitudes = async (query) => {
    if (query.length === 0) {
        throw Error('Query is empty!');
    }
    query.sort((a, b) => a.time - b.time);
    let query_string = `${query[0].lat},${query[0].lng}`;
    for (let i = 1; i < query.length; i += 1) {
        const q = query[i];
        query_string += `,${q.lat},${q.lng}`;
    }
    const apiResponse = await axios.get(
        `${ElevationAPI}/?points=${query_string}`,
        { 'X-API-Key': process.env.ELEVATION_SECRET }
    );
    if (apiResponse.status !== 200) {
        throw Error('Some error occured');
    }
    const { data } = apiResponse.data;
    const minEpoch = query[0].time;
    console.log(data);
    const response = [];
    for (let i = 0; i < data.length; i += 1) {
        const element = data[i];
        const size = element.profile.length;
        if (size === 1) {
            response.push({
                x: (query[i].time - minEpoch) / 1000,
                y: element.profile[0],
            });
        } else {
            const k = (query[i + 1].time - query[i].time) / (size - 1);
            for (let j = 0; j < size; j += 1) {
                // eslint-disable-next-line no-continue
                if (response.length !== 0 && j === 0) continue;
                response.push({
                    x: (query[i].time + k * j - minEpoch) / 1000,
                    y: element.profile[j],
                });
            }
        }
    }
    return response;
};

const geoDecode = async (lat, long) => {
    const apiResponse = await axios.get(
        `${URL}?v=20200919&client_id=${process.env.CLIENT_ID}&client_secret=${process.env.CLIENT_SECRET}&ll=${lat},${long}&limit=1`
    );
    if (apiResponse.status !== 200) {
        throw Error('Location not found');
    }
    const address = apiResponse.data.response.venues[0].location.formattedAddress.join(
        ', '
    );
    return address;
};
const getState = async (lat, long) => {
    const apiResponse = await axios.get(
        `${URL}?v=20200919&client_id=${process.env.CLIENT_ID}&client_secret=${process.env.CLIENT_SECRET}&ll=${lat},${long}&limit=1`
    );
    if (apiResponse.status !== 200) {
        throw Error('Location not found');
    }
    const { state } = apiResponse.data.response.venues[0].location;
    return state;
};

const makeid = (length, alpahnum_only = false) => {
    let result = '';
    const characters = !alpahnum_only
        ? 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,./;:?><[]{}|`~!@#$%^&*()-_=+'
        : 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    const charactersLength = characters.length;
    for (let i = 0; i < length; i += 1) {
        result += characters.charAt(
            Math.floor(Math.random() * charactersLength)
        );
    }
    return result;
};

const CarMD_Url = 'http://api.carmd.com/v3.0/';

const carMD = async (vin, mileage, dtc) => {
    const apiResponse = await axios.post(
        `${CarMD_Url}/repair?vin=${vin}&mileage=${mileage}&dtc=${dtc}`,
        {
            'Parent-Token': process.env.CARMD_PARENT_TOKEN,
            Authorization: process.env.CARMD_TOKEN,
        }
    );
    if (apiResponse.status !== 200) {
        throw Error('No repair data found');
    }
    return apiResponse.data.data;
};

const computeRepairCost = (damagedParts) => {
    return damagedParts.length * 100;
};

const filterByTime = (arr, time, after) => {
    return arr.filter((e) => {
        if (after) return e.x >= time;
        return e.x <= time;
    });
};

const integrate = (arr) => {
    const x = [];
    const y = [];
    arr.forEach((point) => {
        x.push(point.x);
        y.push(point.y);
    });
    let sum = 0;
    for (let i = 0; i < x.length - 1; i += 1) {
        const xi = x[i];
        const dx = x[i + 1] - xi;
        sum += ((y[i] + y[i + 1]) / 2) * dx;
    }
    return sum / 1000;
};
const convertEpoch = (arr, offset) => {
    const result = [];

    arr.forEach((e) => {
        const { y } = e;
        const time = (e.x - offset) / 1000;
        result.push({
            x: time,
            y,
        });
    });
    return result;
};

const getNetForce = (a1, a2, a3) => {
    const minSize = Math.min(a1.length, a2.length, a3.length);
    const mass = 1500;
    const result = [];
    for (let i = 0; i < minSize; i += 1) {
        const norm = Math.sqrt(
            a1[i].y * a1[i].y + a2[i].y * a2[i].y + a3[i].y * a3[i].y
        );
        result.push({
            x: a1[i].x,
            y: mass * norm,
        });
    }
    return result;
};
const getCrashDistance = () => {
    let filteredSpeeds = filterByTime(
        keys.crashData.gps_speed,
        keys.crashData.start_time,
        true
    );
    filteredSpeeds = filterByTime(
        filteredSpeeds,
        keys.crashData.main_impact_time,
        false
    );
    return integrate(filteredSpeeds);
};
const legalAdvisor = () => {
    const response = [];
    const { crashData } = keys;
    let point = {
        heading: 'Phone Usage prior to the crash',
    };
    const positiveAdvice = (e) => {
        return `There is no evidence that you ${e}. You can use this to strengthen your claim.`;
    };
    const negativeAdvice = (e) => {
        return `It has been noticed that you ${e}. The plaintiff can use this to weaken your claim`;
    };
    if (crashData.prior_phone_usage) {
        point.advice = negativeAdvice(
            'were using phone within a 60 sec time window prior to the crash time'
        );
        point.status = 'negative';
    } else {
        point.advice = positiveAdvice(
            'had used the phone within a 60 sec time window prior to the crash'
        );
        point.status = 'positive';
    }
    response.push(point);
    point = {
        heading: 'Speeding prior to the crash',
    };
    if (crashData.prior_speeding) {
        point.advice = negativeAdvice(
            'were speeding within a 60 sec window frame prior to the crash'
        );
        point.status = 'negative';
    } else {
        point.advice = positiveAdvice(
            'were speeding within a 60 sec window frame prior to the crash'
        );
        point.status = 'positive';
    }
    response.push(point);
    point = {
        heading: 'Evasive measures',
    };
    if (crashData.driver_maneuver === 'No Reaction') {
        point.advice = negativeAdvice(
            'did not take any evasive measure to avoid the accident.'
        );
        point.status = 'negative';
    } else {
        point.advice = positiveAdvice(
            `took evasive measures such as ${crashData.driver_maneuver} to avoid the accident`
        );
        point.status = 'positive';
    }
    response.push(point);
    point = {
        heading: 'Continued driving after crash',
    };
    if (crashData.continue_driving && crashData.severity > 50) {
        point.advice = negativeAdvice(
            'continued driving even though the accident was severe'
        );
        point.status = 'negative';
    } else if (crashData.continue_driving && crashData.severity < 50) {
        point.advice =
            'The accident was not that severe and you continued your driving';
        point.status = 'positive';
    } else if (crashData.continue_driving && crashData.severity > 50) {
        point.advice =
            'The accident was quite severe and you did not continue your driving. This could be used to strengthen your claim';
        point.status = 'positive';
    } else {
        point.advice =
            'The accident was not even severe and you did not continue your driving';
        point.status = 'positive';
    }
    response.push(point);
    point = {
        heading: 'Deployment of airbags',
    };
    if (!crashData.airbag_deployed) {
        point.advice = positiveAdvice(
            'could have been saved by an airbag since the airbag was not deployed'
        );
        point.status = 'positive';
    } else {
        point.advice = negativeAdvice(
            'could have been saved by an airbag, since the airbag was deployed correctly.'
        );
        point.status = 'negative';
    }
    response.push(point);
    return response;
};
//
export {
    makeid,
    createJWTtoken,
    verifyToken,
    getCrashDistance,
    convertEpoch,
    getNetForce,
    legalAdvisor,
    geoDecode,
    computeRepairCost,
    getState,
    computeAltitudes,
    carMD,
};
