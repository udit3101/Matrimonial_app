const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql2');
const twilio = require('twilio');
const cloudinary = require('cloudinary').v2;
// Configure Cloudinary with your Cloudinary credentials


const app = express();
const port = 3000;
cloudinary.config({
    cloud_name: 'dxvii6qjr',
    api_key: '224145425268199',
    api_secret: 'NL1VGgK5xmy17nnL6Et6T5N0DPA'
  });
// Middleware
const accountSid = 'ACb6c30ff0cfb7eece9289638fe41bfbc6';
const authToken = '9f9f4c8f94e5287a36783010f5bb5118';
const twilioClient = twilio(accountSid, authToken);
const multer = require('multer');

// Multer storage configuration
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });


app.use(bodyParser.json());

// MySQL connection
const connection = mysql.createConnection({
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

app.post('/users', upload.single('profileImage'), (req, res) => {
    const { firstName, lastName, email, username, mobile, password, dob, religion, gender,friends, height } = req.body;
    const profileImage = req.file ? req.file.buffer : null; // Store image as buffer

    // Check if mobile number is already registered
    const checkMobileQuery = 'SELECT * FROM users WHERE mobile = ?';
    connection.query(checkMobileQuery, [mobile], (err, results) => {
        if (err) {
            console.error('Error checking mobile number:', err.stack);
            res.status(500).json({ error: 'Error checking mobile number' });
            return;
        }
        if (results.length > 0) {
            res.status(400).json({ error: 'Mobile number is already registered' });
            return;
        }

        // If mobile number is unique, proceed with user creation
        const insertUserQuery = 'INSERT INTO users (firstName, lastName, email, username, mobile, password, dob, religion, gender, friends,height, profileImage) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?,?, ?, ?)';
        connection.query(insertUserQuery, [firstName, lastName, email, username, mobile, password, dob, religion, gender,friends, height, profileImage], (err, result) => {
            if (err) {
                console.error('Error creating user:', err.stack);
                res.status(500).json({ error: 'Error creating user' });
                return;
            }
            const user = { id: result.insertId, firstName, lastName, email, username, mobile, dob, religion, gender, height, profileImage };
            res.status(201).json(user);
        });
    });
});

app.post('/hobbies', (req, res) => {
    const { mobile, hobbies } = req.body;

    // Check if mobile number is provided
    if (!mobile) {
        res.status(400).json({ error: 'Mobile number must be provided' });
        return;
    }

    // Check if hobbies array is provided
    if (!Array.isArray(hobbies)) {
        res.status(400).json({ error: 'Hobbies must be provided as an array' });
        return;
    }

    // Convert hobbies array to JSON string
    const hobbiesJSON = JSON.stringify(hobbies);

    // Proceed with updating hobbies for the user with the given mobile number
    const updateHobbiesQuery = 'UPDATE users SET hobbies = ? WHERE mobile = ?';
    connection.query(updateHobbiesQuery, [hobbiesJSON, mobile], (err, result) => {
        if (err) {
            console.error('Error updating hobbies:', err.stack);
            res.status(500).json({ error: 'Error updating hobbies' });
            return;
        }
        if (result.affectedRows === 0) {
            res.status(404).json({ error: 'User not found' });
            return;
        }
        res.status(200).json({ message: 'Hobbies updated successfully' });
    });
});



app.post('/uploaddet', upload.single('image'), async (req, res) => {
    try {
      const { mobile, text } = req.body;
      const imageFile = req.file;
  
      // Check if image file was uploaded
      if (!imageFile) {
        return res.status(400).json({ error: 'Image file is required' });
      }
  
      // Store image file in blob format directly into MySQL
      const insertDetailsQuery =  'UPDATE users SET About = ? , profileImage = ? WHERE mobile = ?';
      connection.query(insertDetailsQuery, [ text, imageFile.buffer,mobile], (insertErr, insertResult) => {
        if (insertErr) {
          console.error('Error inserting details:', insertErr.stack);
          res.status(500).json({ error: 'Error inserting details' });
          return;
        }
        res.status(200).json({ message: 'Data uploaded successfully' });
      });
    } catch (error) {
      console.error('Internal Server Error:', error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  });




app.post('/userdetails', (req, res) => {
    const { mobile, education, placeOfBirth, profession, diet, drink, smoke } = req.body;

    // Check if all required parameters are provided
    if (!mobile || !education || !placeOfBirth || !profession || !diet || !drink || !smoke) {
        res.status(400).json({ error: 'All fields must be provided' });
        return;
    }

    // Check if user exists with the given mobile number
    const checkUserQuery = 'SELECT * FROM users WHERE mobile = ?';
    connection.query(checkUserQuery, [mobile], (checkErr, checkResult) => {
        if (checkErr) {
            console.error('Error checking user:', checkErr.stack);
            res.status(500).json({ error: 'Error checking user' });
            return;
        }

        // If user doesn't exist, return an error
        if (checkResult.length === 0) {
            res.status(404).json({ error: 'User not found with the given mobile number' });
            return;
        }

        // User exists, proceed with inserting details
        const insertDetailsQuery = 'UPDATE users SET Education = ?, Place_of_birth = ?, Profession = ?, Diet = ?, Drink = ?, Smoke = ? WHERE mobile = ?';
        connection.query(insertDetailsQuery, [education, placeOfBirth, profession, diet, drink, smoke, mobile], (insertErr, insertResult) => {
            if (insertErr) {
                console.error('Error inserting details:', insertErr.stack);
                res.status(500).json({ error: 'Error inserting details' });
                return;
            }
            res.status(200).json({ message: 'User details updated successfully' });
        });
    });
});





// Search for users by name
app.get('/users/search', (req, res) => {
    const { username } = req.query;
    const query = 'SELECT * FROM users WHERE username LIKE ?';
    connection.query(query, ['%' + username + '%'], (err, results) => {
        if (err) {
            console.error('Error searching for users: ' + err.stack);
            res.status(500).json({ error: 'Error searching for users' });
            return;
        }
        res.status(200).json(results);
    });
});


// Send friend request
app.post('/friendRequests', (req, res) => {
    const { fromUserId, toUserId } = req.body;
    const selectQuery = 'SELECT * FROM friend_requests WHERE (from_user_id = ? AND to_user_id = ?) OR (from_user_id = ? AND to_user_id = ?)';
    connection.query(selectQuery, [fromUserId, toUserId, toUserId, fromUserId], (selectErr, selectResult) => {
        if (selectErr) {
            console.error('Error checking existing friend request: ' + selectErr.stack);
            res.status(500).json({ error: 'Error checking existing friend request' });
            return;
        }

        if (selectResult.length > 0) {
            // Friend request already exists in either direction
            res.status(400).json({ error: 'Friend request already exists' });
            return;
        }

        // If no existing request found, proceed to insert new request
        const insertQuery = 'INSERT INTO friend_requests (from_user_id, to_user_id) VALUES (?, ?)';
        connection.query(insertQuery, [fromUserId, toUserId], (insertErr, result) => {
            if (insertErr) {
                console.error('Error sending friend request: ' + insertErr.stack);
                res.status(500).json({ error: 'Error sending friend request' });
                return;
            }
            const request = { id: result.insertId, fromUserId, toUserId, status: 'pending' };
            res.status(201).json(request);
        });
    });
});


// Send friend request
app.post('/friendRequestsd', (req, res) => {
    const { fromUserId, toUserId } = req.body;
    const selectQuery = 'SELECT * FROM friend_requests WHERE from_user_id = ? AND to_user_id = ?';
    connection.query(selectQuery, [fromUserId, toUserId], (selectErr, selectResult) => {
        if (selectErr) {
            console.error('Error checking existing friend request: ' + selectErr.stack);
            res.status(500).json({ error: 'Error checking existing friend request' });
            return;
        }

        if (selectResult.length > 0) {
            // Friend request already exists
            res.status(400).json({ error: 'Friend request already exists' });
            return;
        }

        // If no existing request found, proceed to insert new request
        const insertQuery = 'INSERT INTO friend_requests (from_user_id, to_user_id) VALUES (?, ?)';
        connection.query(insertQuery, [fromUserId, toUserId], (insertErr, result) => {
            if (insertErr) {
                console.error('Error sending friend request: ' + insertErr.stack);
                res.status(500).json({ error: 'Error sending friend request' });
                return;
            }
            const request = { id: result.insertId, fromUserId, toUserId, status: 'pending' };
            res.status(201).json(request);
        });
    });
});



app.put('/friendRequests/:userId/:fromUserId', (req, res) => {
    const userId = parseInt(req.params.userId);
    const fromUserId = parseInt(req.params.fromUserId);
    const { status } = req.body;

    // Check if the request has already been accepted
    const checkRequestQuery = 'SELECT status FROM friend_requests WHERE to_user_id = ? AND from_user_id = ?';
    connection.query(checkRequestQuery, [userId, fromUserId], (err, result) => {
        if (err) {
            console.error('Error checking friend request status: ' + err.stack);
            res.status(500).json({ error: 'Error checking friend request status' });
            return;
        }

        if (result.length > 0 && result[0].status === 'accepted') {
            res.status(400).json({ error: 'Friend request already accepted' });
            return;
        }

        // If request is not already accepted, update the status
        const updateQuery = 'UPDATE friend_requests SET status = ? WHERE to_user_id = ? AND from_user_id = ?';
        connection.query(updateQuery, [status, userId, fromUserId], (err, updateResult) => {
            if (err) {
                console.error('Error updating friend request: ' + err.stack);
                res.status(500).json({ error: 'Error updating friend request' });
                return;
            }

            if (updateResult.affectedRows === 0) {
                res.status(404).json({ error: 'Friend request not found for the user' });
                return;
            }

            if (status === 'accepted') {
                // Update the friends array in the users table for both users
                updateFriendsArray(userId, fromUserId, () => {
                    updateFriendsArray(fromUserId, userId, () => {
                        res.status(200).json({ message: 'Friend request accepted successfully' });
                    });
                });
            } else {
                res.status(200).json({ message: 'Friend request declined successfully' });
            }
        });
    });
});

function updateFriendsArray(userId, friendId, callback) {
    // Fetch current friends array from the users table
    const fetchQuery = 'SELECT friends FROM users WHERE id = ?';
    connection.query(fetchQuery, [userId], (err, result) => {
        if (err) {
            console.error('Error fetching friends array: ' + err.stack);
            return callback(err);
        }

        // Parse the JSON array or initialize an empty array if it's null
        let friendsArray = result[0].friends ? JSON.parse(result[0].friends) : [];

        // Add the friendId to the array if it's not already present
        if (!friendsArray.includes(friendId)) {
            friendsArray.push(friendId);
        }

        // Update the friends array in the users table
        const updateQuery = 'UPDATE users SET friends = ? WHERE id = ?';
        connection.query(updateQuery, [JSON.stringify(friendsArray), userId], (err, updateResult) => {
            if (err) {
                console.error('Error updating friends array: ' + err.stack);
                return callback(err);
            }
            return callback(null);
        });
    });
}
// Generate and send OTP code
app.post('/sendOTP', (req, res) => {
    const { phoneNumber } = req.body;
    const otp = Math.floor(100000 + Math.random() * 900000); // Generate a 6-digit OTP code

    twilioClient.messages
        .create({
            body: `Your OTP code to use mat app  is: ${otp}`,
            from: '+16185905856',
            to: phoneNumber
        })
        .then(() => {
            res.status(200).json({ message: 'OTP sent successfully', otp });
        })
        .catch((err) => {
            console.error('Error sending OTP:', err);
            res.status(500).json({ error: 'Error sending OTP' });
        });
});

// Verify OTP code
app.post('/verifyOTP', (req, res) => {
    const { otp, enteredOTP } = req.body;

    if (otp === enteredOTP) {
        res.status(200).json({ message: 'OTP verification successful' });
    } else {
        res.status(400).json({ error: 'Invalid OTP code' });
    }
});


app.post('/login', (req, res) => {
    const { credential, password } = req.body;
    const query = 'SELECT * FROM users WHERE (mobile = ? ) AND password = ?';
    connection.query(query, [credential, password], (err, results) => {
      if (err) {
        console.error('Error authenticating user:', err);
        res.status(500).json({ error: 'Internal server error' });
      } else if (results.length > 0) {
        res.status(200).json({ message: 'Login successful', user: results[0] });
      } else {
        res.status(401).json({ error: 'Invalid mobile number/email or password' });
      }
    });
});






app.get('/mobileget', (req, res) => {
    const { email } = req.query;
  
    if (!email) {
      res.status(400).json({ error: 'Email is required' });
      return;
    }
  
    const getMobileQuery = 'SELECT mobile FROM users WHERE email = ?';
    connection.query(getMobileQuery, [email], (err, results) => {
      if (err) {
        console.error('Error fetching mobile number:', err.stack);
        res.status(500).json({ error: 'Error fetching mobile number' });
        return;
      }
      if (results.length === 0) {
        res.status(404).json({ error: 'Mobile number not found for the given email' });
        return;
      }
      const mobile = results[0].mobile;
      res.status(200).json({ mobile });
    });
  });

app.post('/loginem', (req, res) => {
    const { credential, password } = req.body;
    const query = 'SELECT * FROM users WHERE (email = ? ) AND password = ?';
    connection.query(query, [credential, password], (err, results) => {
      if (err) {
        console.error('Error authenticating user:', err);
        res.status(500).json({ error: 'Internal server error' });
      } else if (results.length > 0) {
        res.status(200).json({ message: 'Login successful', user: results[0] });
      } else {
        res.status(401).json({ error: 'Invalid mobile number/email or password' });
      }
    });
});

  
  // Request OTP for password reset



  app.post('/reset-password', (req, res) => {
    const { mobileNumber, newPassword } = req.body;
  
    // Find user by mobile number
    const query = 'SELECT * FROM users WHERE mobile = ?';
    connection.query(query, [mobileNumber], (err, results) => {
      if (err) {
        console.error('Error querying database:', err);
        return res.status(500).json({ message: 'Internal server error' });
      }
  
      if (results.length === 0) {
        return res.status(404).json({ message: 'User not found' });
      }
  
      // Update user's password
      const updateQuery = 'UPDATE users SET password = ? WHERE mobile = ?';
      connection.query(updateQuery, [newPassword, mobileNumber], (err) => {
        if (err) {
          console.error('Error updating password:', err);
          return res.status(500).json({ message: 'Internal server error' });
        }
        return res.status(200).json({ message: 'Password updated successfully' });
      });
    });
  });






  
app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
