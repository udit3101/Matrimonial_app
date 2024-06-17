const express = require('express');
const bodyParser = require('body-parser');
const twilio = require('twilio');
const mysql2 = require('mysql2');
const app = express();
const port = 3200;

// Initialize Twilio client

// Middleware

app.use(bodyParser.json());

// MySQL connection
const connection = mysql2.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'friend_requests_database'
});

connection.connect(err => {
    if (err) {
        console.error('Error connecting to MySQL database: ' + err.stack);
        return;
    }
    console.log('Connected to MySQL database');
});
app.get('/username', (req, res) => {
    const { mobile } = req.query;

    // Check if mobile number is provided
    if (!mobile) {
        res.status(400).json({ error: 'Mobile number must be provided' });
        return;
    }

    // Query the database to fetch the username for the given mobile number
    const getUsernameQuery = 'SELECT username FROM users WHERE mobile = ?';
    connection.query(getUsernameQuery, [mobile], (err, results) => {
        if (err) {
            console.error('Error fetching username:', err.stack);
            res.status(500).json({ error: 'Error fetching username' });
            return;
        }
        if (results.length === 0) {
            res.status(404).json({ error: 'Username not found for the given mobile number' });
            return;
        }
        const username = results[0].username;
        res.status(200).json({ username });
    });
});




app.get('/folor', (req, res) => {
    const { id } = req.query;

    // Check if mobile number is provided
   
    // Query the database to fetch the username for the given mobile number
    const getfollowerQuery = 'SELECT followers FROM users WHERE id = ?';
    connection.query(getfollowerQuery, [id], (err, results) => {
        if (err) {
            console.error('Error fetching follower:', err.stack);
            res.status(500).json({ error: 'Error fetching follower' });
            return;
        }
        if (results.length === 0) {
            res.status(404).json({ error: 'follower not found for the given mobile number' });
            return;
        }
        const flr = results[0].followers;
        res.status(200).json({ flr });
    });
});






app.get('/religion', (req, res) => {
    const { mobile } = req.query;

    // Check if mobile number is provided
    if (!mobile) {
        res.status(400).json({ error: 'Mobile number must be provided' });
        return;
    }

    // Query the database to fetch the username for the given mobile number
    const getreligionquery = 'SELECT religion FROM users WHERE mobile = ?';
    connection.query(getreligionquery, [mobile], (err, results) => {
        if (err) {
            console.error('Error fetching username:', err.stack);
            res.status(500).json({ error: 'Error fetching username' });
            return;
        }
        if (results.length === 0) {
            res.status(404).json({ error: 'Username not found for the given mobile number' });
            return;
        }
        const religion = results[0].religion;
        res.status(200).json({ religion });
    });
});







app.get('/email', (req, res) => {
    const { mobile } = req.query;

    // Check if mobile number is provided
    if (!mobile) {
        res.status(400).json({ error: 'Mobile number must be provided' });
        return;
    }

    // Query the database to fetch the email for the given mobile number
    const emailquery = 'SELECT email FROM users WHERE mobile = ?';
    connection.query(emailquery, [mobile], (err, results) => {
        if (err) {
            console.error('Error fetching email:', err.stack);
            res.status(500).json({ error: 'Error fetching email' });
            return;
        }
        if (results.length === 0) {
            res.status(404).json({ error: 'Email not found for the given mobile number' });
            return;
        }
        const email = results[0].email;
        res.status(200).json({ email });
    });
});


app.get('/firstname', (req, res) => {
    const { mobile } = req.query;

    // Check if mobile number is provided
    if (!mobile) {
        res.status(400).json({ error: 'Mobile number must be provided' });
        return;
    }

    // Query the database to fetch the first name for the given mobile number
    const getFirstNameQuery = 'SELECT firstName FROM users WHERE mobile = ?';
    connection.query(getFirstNameQuery, [mobile], (err, results) => {
        if (err) {
            console.error('Error fetching first name:', err.stack);
            res.status(500).json({ error: 'Error fetching first name' });
            return;
        }
        if (results.length === 0) {
            res.status(404).json({ error: 'First name not found for the given mobile number' });
            return;
        }
        const firstName = results[0].firstName;
        res.status(200).json({ firstName });
    });
});





app.get('/lastname', (req, res) => {
    const { mobile } = req.query;

    // Check if mobile number is provided
    if (!mobile) {
        res.status(400).json({ error: 'Mobile number must be provided' });
        return;
    }

    // Query the database to fetch the last name for the given mobile number
    const getLastNameQuery = 'SELECT lastName FROM users WHERE mobile = ?';
    connection.query(getLastNameQuery, [mobile], (err, results) => {
        if (err) {
            console.error('Error fetching last name:', err.stack);
            res.status(500).json({ error: 'Error fetching last name' });
            return;
        }
        if (results.length === 0) {
            res.status(404).json({ error: 'Last name not found for the given mobile number' });
            return;
        }
        const lastName = results[0].lastName;
        res.status(200).json({ lastName });
    });
});













app.get('/education', (req, res) => {
    const { mobile } = req.query;

    // Check if mobile number is provided
    if (!mobile) {
        res.status(400).json({ error: 'Mobile number must be provided' });
        return;
    }

    // Query the database to fetch the last name for the given mobile number
    const geteduQuery = 'SELECT Education FROM users WHERE mobile = ?';
    connection.query(geteduQuery, [mobile], (err, results) => {
        if (err) {
            console.error('Error fetching Education:', err.stack);
            res.status(500).json({ error: 'Error fetching education' });
            return;
        }
        if (results.length === 0) {
            res.status(404).json({ error: 'Education not found for the given mobile number' });
            return;
        }
        const Education = results[0].Education;
        res.status(200).json({ Education });
    });
});






















app.get('/job', (req, res) => {
    const { mobile } = req.query;

    // Check if mobile number is provided
    if (!mobile) {
        res.status(400).json({ error: 'Mobile number must be provided' });
        return;
    }

    // Query the database to fetch the last name for the given mobile number
    const getjob = 'SELECT Profession FROM users WHERE mobile = ?';
    connection.query(getjob, [mobile], (err, results) => {
        if (err) {
            console.error('Error fetching Profession:', err.stack);
            res.status(500).json({ error: 'Error fetching Profession' });
            return;
        }
        if (results.length === 0) {
            res.status(404).json({ error: 'Profession not found for the given mobile number' });
            return;
        }
        const profession = results[0].Profession;
        res.status(200).json({ profession });
    });
});












app.get('/place', (req, res) => {
    const { mobile } = req.query;

    // Check if mobile number is provided
    if (!mobile) {
        res.status(400).json({ error: 'Mobile number must be provided' });
        return;
    }

    // Query the database to fetch the last name for the given mobile number
    const getplace = 'SELECT Place_of_birth FROM users WHERE mobile = ?';
    connection.query(getplace, [mobile], (err, results) => {
        if (err) {
            console.error('Error fetching Place:', err.stack);
            res.status(500).json({ error: 'Error fetching Place' });
            return;
        }
        if (results.length === 0) {
            res.status(404).json({ error: 'Place not found for the given mobile number' });
            return;
        }
        const place = results[0].Place_of_birth;
        res.status(200).json({ place });
    });
});















app.get('/smoke', (req, res) => {
    const { mobile } = req.query;

    // Check if mobile number is provided
    if (!mobile) {
        res.status(400).json({ error: 'Mobile number must be provided' });
        return;
    }

    // Query the database to fetch the last name for the given mobile number
    const getsmoke = 'SELECT Smoke FROM users WHERE mobile = ?';
    connection.query(getsmoke, [mobile], (err, results) => {
        if (err) {
            console.error('Error fetching Smoke:', err.stack);
            res.status(500).json({ error: 'Error fetching Smoke' });
            return;
        }
        if (results.length === 0) {
            res.status(404).json({ error: 'Smoke not found for the given mobile number' });
            return;
        }
        const smoke = results[0].Smoke;
        res.status(200).json({ smoke });
    });
});






app.get('/diet', (req, res) => {
    const { mobile } = req.query;

    // Check if mobile number is provided
    if (!mobile) {
        res.status(400).json({ error: 'Mobile number must be provided' });
        return;
    }

    // Query the database to fetch the last name for the given mobile number
    const getdiet = 'SELECT Diet FROM users WHERE mobile = ?';
    connection.query(getdiet, [mobile], (err, results) => {
        if (err) {
            console.error('Error fetching Diet:', err.stack);
            res.status(500).json({ error: 'Error fetching Diet' });
            return;
        }
        if (results.length === 0) {
            res.status(404).json({ error: 'Diet not found for the given mobile number' });
            return;
        }
        const diet = results[0].Diet;
        res.status(200).json({ diet });
    });
});






app.get('/drink', (req, res) => {
    const { mobile } = req.query;

    // Check if mobile number is provided
    if (!mobile) {
        res.status(400).json({ error: 'Mobile number must be provided' });
        return;
    }

    // Query the database to fetch the last name for the given mobile number
    const getdrink = 'SELECT Drink FROM users WHERE mobile = ?';
    connection.query(getdrink, [mobile], (err, results) => {
        if (err) {
            console.error('Error fetching Drink:', err.stack);
            res.status(500).json({ error: 'Error fetching Drink' });
            return;
        }
        if (results.length === 0) {
            res.status(404).json({ error: 'Drink not found for the given mobile number' });
            return;
        }
        const drink = results[0].Drink;
        res.status(200).json({ drink });
    });
});











app.get('/height', (req, res) => {
    const { mobile } = req.query;

    // Check if mobile number is provided
    if (!mobile) {
        res.status(400).json({ error: 'Mobile number must be provided' });
        return;
    }

    // Query the database to fetch the height for the given mobile number
    const getHeightQuery = 'SELECT height FROM users WHERE mobile = ?';
    connection.query(getHeightQuery, [mobile], (err, results) => {
        if (err) {
            console.error('Error fetching height:', err.stack);
            res.status(500).json({ error: 'Error fetching height' });
            return;
        }
        if (results.length === 0) {
            res.status(404).json({ error: 'Height not found for the given mobile number' });
            return;
        }
        const height = results[0].height;
        res.status(200).json({ height });
    });
});




app.get('/dob', (req, res) => {
    const { mobile } = req.query;

    // Check if mobile number is provided
    if (!mobile) {
        res.status(400).json({ error: 'Mobile number must be provided' });
        return;
    }

    // Query the database to fetch the date of birth (DOB) for the given mobile number
    const getDobQuery = 'SELECT DATE_FORMAT(dob, "%Y-%m-%d") AS dob FROM users WHERE mobile = ?';
    connection.query(getDobQuery, [mobile], (err, results) => {
        if (err) {
            console.error('Error fetching date of birth (DOB):', err.stack);
            res.status(500).json({ error: 'Error fetching date of birth (DOB)' });
            return;
        }
        if (results.length === 0) {
            res.status(404).json({ error: 'Date of birth (DOB) not found for the given mobile number' });
            return;
        }
        const dob = results[0].dob;
        res.status(200).json({ dob });
    });
});




 



app.get('/hobbies', (req, res) => {
    const { mobile } = req.query;

    // Check if mobile number is provided
    if (!mobile) {
        res.status(400).json({ error: 'Mobile number must be provided' });
        return;
    }

    // Query the database to fetch hobbies for the given mobile number
    const getHobbiesQuery = 'SELECT hobbies FROM users WHERE mobile = ?';
    connection.query(getHobbiesQuery, [mobile], (err, results) => {
        if (err) {
            console.error('Error fetching hobbies:', err.stack);
            res.status(500).json({ error: 'Error fetching hobbies' });
            return;
        }
        if (results.length === 0) {
            res.status(404).json({ error: 'Hobbies not found for the given mobile number' });
            return;
        }
        const hobbiesJSON = results[0].hobbies;
        const hobbies = JSON.parse(hobbiesJSON);
        res.status(200).json({ hobbies });
    });
});












app.post('/updateFollowers', (req, res) => {
    const userId = req.body.userId; // User ID provided in the request body

    // Query to fetch the friend's details
    const selectQuery = 'SELECT friends FROM users WHERE id = ?';

    connection.query(selectQuery, [userId], (err, result) => {
        if (err) {
            console.error('Error fetching friend details:', err);
            res.status(500).json({ error: 'Error fetching friend details' });
            return;
        }

        if (result.length === 0) {
            res.status(404).json({ error: 'Friend details not found for the provided user ID' });
            return;
        }

        const details = result[0].friends;

        // Calculate the length of the details array
        const followersCount = details.length;

        // Update the followers column in the friends table
        const updateQuery = 'UPDATE users SET followers = ? WHERE id = ?';

        connection.query(updateQuery, [followersCount, userId], (err, result) => {
            if (err) {
                console.error('Error updating followers:', err);
                res.status(500).json({ error: 'Error updating followers' });
            } else {
                res.status(200).json({ message: 'Followers count updated successfully' });
            }
        });
    });
});





app.get('/follower', (req, res) => {
    const { mobile } = req.query;

    // Check if mobile number is provided
   

    // Query the database to fetch the height for the given mobile number
    const getHeightQuery = 'SELECT followers FROM users WHERE mobile = ?';
    connection.query(getHeightQuery, [mobile], (err, results) => {
        if (err) {
            console.error('Error fetching height:', err.stack);
            res.status(500).json({ error: 'Error fetching height' });
            return;
        }
        if (results.length === 0) {
            res.status(404).json({ error: 'Followers not found for the given mobile number' });
            return;
        }
        const flr = results[0].followers;
        res.status(200).json({ flr });
    });
});



// Start the server
app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
