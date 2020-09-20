import express from 'express';
import bodyParser from 'body-parser';
import mongoose from 'mongoose';
import cors from 'cors';
import cookieParser from 'cookie-parser';
import user from './routes/user';
import api from './routes/api';

require('dotenv').config({
    path: `${__dirname}/../.env`,
});

const app = express();

app.use(cors());
app.use(cookieParser()); // pass a string inside function to encrypt cookies

// Body Parser Middleware
// parse application/x-www-form-urlencoded (for ejs page requests)
app.use(bodyParser.urlencoded());
// parse json
app.use(bodyParser.json());

// export .env from previous folder

const db_url = process.env.DB_URL;

// Connect to database
mongoose
    .connect(db_url, {
        useNewUrlParser: true,
        useCreateIndex: true,
        useFindAndModify: false,
        useUnifiedTopology: true,
    })
    .then(() => {
        console.log('Connected to the database...');
    })
    .catch((err) => {
        console.log(err);
    });

// Root page
app.get('/', (req, res) => {
    return res.sendStatus(200);
});

app.use('/user', user);
app.use('/api', api);

const port = process.env.PORT;

app.listen(port, () => {
    console.log(`Server listening on ${port}!`);
});
