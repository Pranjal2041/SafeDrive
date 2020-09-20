const fs = require('fs');
const path = require('path');

export const expTime = 365 * 24 * 60 * 60 * 20;
export const rememberTime = 365 * 24 * 60 * 60 * 1000;
export const accessTokenName = 'token';
export const refreshTokenName = 'rememberme';
export const iss = 'cmt';
export const privateKey = fs.readFileSync(
    path.resolve(__dirname, './private.pem')
);
export const publicKey = fs.readFileSync(
    path.resolve(__dirname, './public.pem')
);
export const crashData = JSON.parse(
    fs.readFileSync(path.resolve(__dirname, './data.json'))
);
export const crashData1 = JSON.parse(
    fs.readFileSync(path.resolve(__dirname, './data1.json'))
);
export const deathRate = JSON.parse(
    fs.readFileSync(path.resolve(__dirname, './death-rate.json'))
);

export const categoryIDs = {
    hospital: '4bf58dd8d48988d104941735',
    lawyer: '52f2ab2ebcbc57f1066b8b3f',
    repair: '52f2ab2ebcbc57f1066b8b2f',
};
export const dictionary = [
    {
        time: 23,
        cost: 5,
        type: 'good',
    },
    {
        time: 14,
        cost: 12,
        type: 'good',
    },
    {
        time: 10,
        cost: 5,
        type: 'ok',
    },
    {
        time: 9,
        cost: 4,
        type: 'ok',
    },
    {
        time: 3,
        cost: 3,
        type: 'good',
    },
    {
        time: 1,
        cost: 2,
        type: 'bad',
    },
    {
        time: 1,
        cost: 2,
        type: 'ok',
    },
];

export const states_hash = {
    Alabama: 'AL',
    Alaska: 'AK',
    'American Samoa': 'AS',
    Arizona: 'AZ',
    Arkansas: 'AR',
    California: 'CA',
    Colorado: 'CO',
    Connecticut: 'CT',
    Delaware: 'DE',
    'District Of Columbia': 'DC',
    'Federated States Of Micronesia': 'FM',
    Florida: 'FL',
    Georgia: 'GA',
    Guam: 'GU',
    Hawaii: 'HI',
    Idaho: 'ID',
    Illinois: 'IL',
    Indiana: 'IN',
    Iowa: 'IA',
    Kansas: 'KS',
    Kentucky: 'KY',
    Louisiana: 'LA',
    Maine: 'ME',
    'Marshall Islands': 'MH',
    Maryland: 'MD',
    Massachusetts: 'MA',
    Michigan: 'MI',
    Minnesota: 'MN',
    Mississippi: 'MS',
    Missouri: 'MO',
    Montana: 'MT',
    Nebraska: 'NE',
    Nevada: 'NV',
    'New Hampshire': 'NH',
    'New Jersey': 'NJ',
    'New Mexico': 'NM',
    'New York': 'NY',
    'North Carolina': 'NC',
    'North Dakota': 'ND',
    'Northern Mariana Islands': 'MP',
    Ohio: 'OH',
    Oklahoma: 'OK',
    Oregon: 'OR',
    Palau: 'PW',
    Pennsylvania: 'PA',
    'Puerto Rico': 'PR',
    'Rhode Island': 'RI',
    'South Carolina': 'SC',
    'South Dakota': 'SD',
    Tennessee: 'TN',
    Texas: 'TX',
    Utah: 'UT',
    Vermont: 'VT',
    'Virgin Islands': 'VI',
    Virginia: 'VA',
    Washington: 'WA',
    'West Virginia': 'WV',
    Wisconsin: 'WI',
    Wyoming: 'WY',
};
