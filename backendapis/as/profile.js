const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();

// Enable CORS
app.use(cors());

// MySQL database connection configuration
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'friend_requests_database'
});

// Connect to MySQL
db.connect((err) => {
  if (err) {
    throw err;
  }
  console.log('Connected to MySQL database');
});


// API endpoint to fetch friend requests for a user and accept/decline a request
app.get('/friendRequests/:userId', (req, res) => {
  const userId = req.params.userId;
  const selectQuery = 'SELECT * FROM friend_requests WHERE to_user_id = ?';
  db.query(selectQuery, [userId], (selectErr, selectResult) => {
      if (selectErr) {
          console.error('Error fetching friend requests: ' + selectErr.stack);
          res.status(500).json({ error: 'Error fetching friend requests' });
          return;
      }

      res.status(200).json(selectResult);
  });
});






app.post('/acceptRequest/:requestId', (req, res) => {
  const requestId = req.params.requestId;
  const updateQuery = 'UPDATE friend_requests SET status = "accepted" WHERE id = ?';
  db.query(updateQuery, [requestId], (updateErr, updateResult) => {
    if (updateErr) {
      console.error('Error accepting friend request: ' + updateErr.stack);
      res.status(500).json({ error: 'Error accepting friend request' });
      return;
    }

    const selectQuery = 'SELECT from_user_id, to_user_id FROM friend_requests WHERE id = ?';
    db.query(selectQuery, [requestId], (selectErr, selectResult) => {
      if (selectErr) {
        console.error('Error fetching friend request details: ' + selectErr.stack);
        res.status(500).json({ error: 'Error fetching friend request details' });
        return;
      }
    
      const fromUserId = selectResult[0].from_user_id;
      const toUserId = selectResult[0].to_user_id;
    
      const updateFromUserFriendsQuery = 'UPDATE users SET friends = JSON_ARRAY_APPEND(friends, "$", ?) WHERE id = ?';
      db.query(updateFromUserFriendsQuery, [toUserId, fromUserId], (updateFromUserFriendsErr, updateFromUserFriendsResult) => {
        if (updateFromUserFriendsErr) {
          console.error('Error updating from user\'s friends list: ' + updateFromUserFriendsErr.stack);
          res.status(500).json({ error: 'Error updating from user\'s friends list' });
          return;
        }
    
        const updateToUserFriendsQuery = 'UPDATE users SET friends = JSON_ARRAY_APPEND(friends, "$", ?) WHERE id = ?';
        db.query(updateToUserFriendsQuery, [fromUserId, toUserId], (updateToUserFriendsErr, updateToUserFriendsResult) => {
          if (updateToUserFriendsErr) {
            console.error('Error updating to user\'s friends list: ' + updateToUserFriendsErr.stack);
            res.status(500).json({ error: 'Error updating to user\'s friends list' });
            return;
          }
    

          res.status(200).json({ message: 'Friend request accepted successfully' });
        });
      });
    });
  })    
});


app.post('/declineRequest/:requestId', (req, res) => {
  const requestId = req.params.requestId;
  const updateQuery = 'UPDATE friend_requests SET status = "declined" WHERE id = ?';
  db.query(updateQuery, [requestId], (updateErr, updateResult) => {
      if (updateErr) {
          console.error('Error declining friend request: ' + updateErr.stack);
          res.status(500).json({ error: 'Error declining friend request' });
          return;
      }

      res.status(200).json({ message: 'Friend request declined successfully' });
  });
});







app.post('/increaseFollowerCount/:userId', (req, res) => {
  const userId = req.params.userId;

  // Query to increment the follower count for the user
  const updateQuery = 'UPDATE users SET followers = followers + 1 WHERE id = ?';

  db.query(updateQuery, [userId], (err, result) => {
      if (err) {
          console.error('Error increasing follower count:', err);
          res.status(500).json({ error: 'Error increasing follower count' });
      } else {
          res.status(200).json({ message: 'Follower count increased successfully' });
      }
  });
});









// API endpoint to add a plan for a user with a given ID
app.post('/plan', (req, res) => {
  const userId = req.query.userId;
  const plan = req.query.plan;

  // Check if both userId and plan are provided
  if (!userId || !plan) {
    return res.status(400).json({ error: 'Both userId and plan are required' });
  }

  // SQL query to insert the plan for the user into the database
  const insertQuery = 'UPDATE users SET plans=? where id=?';
  const values = [ plan,userId];

  // Execute the SQL query
  db.query(insertQuery, values, (err, result) => {
    if (err) {
      console.error('Error adding plan:', err);
      res.status(500).json({ error: 'Error adding plan' });
    } else {
      console.log('Plan added successfully');
      res.status(200).json({ message: 'Plan added successfully' });
    }
  });
});

// API endpoint to fetch user details by ID
app.get('/users/:userId', (req, res) => {
    const userId = req.params.userId;
    const sql = `SELECT firstName, lastName, DATE_FORMAT(dob, '%Y-%m-%d') AS dob, email, username, height, religion, gender, profileImage FROM users WHERE id = ?`;
  
    db.query(sql, [userId], (err, result) => {
      if (err) {
        throw err;
      }
      if (result.length > 0) {
        res.json(result[0]); // Return the first user found (assuming user IDs are unique)
      } else {
        res.status(404).json({ message: 'User not found' });
      }
    });
  });
  

  

app.get('/userId/:mobileNumber', (req, res) => {
    const mobileNumber = req.params.mobileNumber;
    const selectQuery = 'SELECT id FROM users WHERE mobile = ?';
    db.query(selectQuery, [mobileNumber], (selectErr, selectResult) => {
        if (selectErr) {
            console.error('Error fetching user ID: ' + selectErr.stack);
            res.status(500).json({ error: 'Error fetching user ID' });
            return;
        }

        if (selectResult.length === 0) {
            // User not found with the given mobile number
            res.status(404).json({ error: 'User not found' });
            return;
        }

        const userId = selectResult[0].id;
        res.status(200).json({ userId: userId });
    });
});







app.get('/userIsd/:email', (req, res) => {
  const email = req.params.email;
  const selectQuery = 'SELECT id FROM users WHERE email = ?';
  db.query(selectQuery, [email], (selectErr, selectResult) => {
      if (selectErr) {
          console.error('Error fetching user ID: ' + selectErr.stack);
          res.status(500).json({ error: 'Error fetching user ID' });
          return;
      }

      if (selectResult.length === 0) {
          // User not found with the given mobile number
          res.status(404).json({ error: 'User not found' });
          return;
      }

      const userId = selectResult[0].id;
      res.status(200).json({ userId: userId });
  });
});







app.get('/username/:mobileNumber', (req, res) => {
  const mobileNumber = req.params.mobileNumber;
  const selectQuery = 'SELECT username FROM users WHERE mobile = ?';
  db.query(selectQuery, [mobileNumber], (selectErr, selectResult) => {
      if (selectErr) {
          console.error('Error fetching username: ' + selectErr.stack);
          res.status(500).json({ error: 'Error fetching username' });
          return;
      }

      if (selectResult.length === 0) {
          // User not found with the given mobile number
          res.status(404).json({ error: 'User not found' });
          return;
      }

      const username = selectResult[0].username;
      res.status(200).json({ username: username });
  });
});



  app.get('/user/:userId/name', (req, res) => {
    const userId = req.params.userId;
    const sql = `SELECT firstName, lastName FROM users WHERE id = ?`;
    
    db.query(sql, [userId], (err, result) => {
      if (err) {
        throw err;
      }
      if (result.length > 0) {
        res.json(result[0]); // Return the first name and last name of the user found
      } else {
        res.status(404).json({ message: 'User not found' });
      }
    });
  });
  
  app.get('/user/:userId/image', (req, res) => {
    const userId = req.params.userId;
    const sql = 'SELECT profileImage FROM users WHERE id = ?';
  
    db.query(sql, [userId], (err, result) => {
      if (err) {
        console.error('Error fetching image:', err);
        res.status(500).json({ error: 'Error fetching image' });
        return;
      }
  
      if (result.length === 0 || result[0].profileImage === null) {
        res.status(404).json({ message: 'Image not found' });
        return;
      }
  
      try {
        // Convert BLOB data to base64 string
        const imageData = Buffer.from(result[0].profileImage, 'binary').toString('base64');
  
        // Construct a data URL (e.g., "data:image/png;base64,...") for the image
        const dataUrl = `data:image/png;base64,${imageData}`;
  
        res.json({ image: dataUrl });
      } catch (error) {
        console.error('Error converting image data:', error);
        res.status(500).json({ error: 'Error converting image data' });
      }
    });
  });
  
  



  


  app.get('/users/:userId/friends', (req, res) => {
    const userId = req.params.userId;
  
    // SQL query to select the friends column for the specified user ID
    const sql = 'SELECT friends FROM users WHERE id = ?';
  
    db.query(sql, [userId], (err, result) => {
      if (err) {
        console.error('Error fetching friends column:', err);
        res.status(500).json({ error: 'Error fetching friends column' });
        return;
      }
  
      if (result.length === 0) {
        res.status(404).json({ message: 'User not found' });
        return;
      }
  
      const friends = JSON.parse(result[0].friends); // Parse the friends column value
      res.json({ friends });
    });
  });
  


  




  app.get('/users/:userId/non-friends', (req, res) => {
    const userId = req.params.userId;
  
    // Query to get the list of friend IDs for the specified user
    const getFriendsSql = 'SELECT friends FROM users WHERE id = ?';
  
    db.query(getFriendsSql, [userId], (err, friendResult) => {
      if (err) {
        console.error('Error fetching friends:', err);
        res.status(500).json({ error: 'Error fetching friends' });
        return;
      }
  
      if (friendResult.length === 0) {
        res.status(404).json({ message: 'User not found' });
        return;
      }
  
      const friends = JSON.parse(friendResult[0].friends); // Parse the list of friend IDs
  
      // Query to get all user IDs except the specified user ID
      const getAllUsersSql = 'SELECT id FROM users WHERE id != ?';
  
      db.query(getAllUsersSql, [userId], (err, allUsersResult) => {
        if (err) {
          console.error('Error fetching all users:', err);
          res.status(500).json({ error: 'Error fetching all users' });
          return;
        }
  
        const allUserIds = allUsersResult.map(user => user.id); // Extract all user IDs
  
        // Filter out the friend IDs from the list of all user IDs
        const nonFriendIds = allUserIds.filter(id => !friends.includes(id));
  
        res.json({ nonFriends: nonFriendIds });
      });
    });
  });

































  
  app.get('/religion', (req, res) => {
    const { id } = req.query;

    // Check if ID is provided
    if (!id) {
        res.status(400).json({ error: 'ID must be provided' });
        return;
    }

    // Query the database to fetch the religion for the given ID
    const getReligionQuery = 'SELECT religion FROM users WHERE id = ?';
    db.query(getReligionQuery, [id], (err, results) => {
        if (err) {
            console.error('Error fetching religion:', err.stack);
            res.status(500).json({ error: 'Error fetching religion' });
            return;
        }
        if (results.length === 0) {
            res.status(404).json({ error: 'Religion not found for the given ID' });
            return;
        }
        const religion = results[0].religion;
        res.status(200).json({ religion });
    });
});

// Update similar endpoints for email, first name, last name, height, dob, and hobbies





app.get('/username', (req, res) => {
    const { id } = req.query;

    // Check if mobile number is provided
   

    // Query the database to fetch the username for the given mobile number
    const getUsernameQuery = 'SELECT username FROM users WHERE id = ?';
    db.query(getUsernameQuery, [id], (err, results) => {
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









app.get('/about', (req, res) => {
  const { id } = req.query;

  // Check if ID is provided
  if (!id) {
      res.status(400).json({ error: 'ID must be provided' });
      return;
  }

  // Query the database to fetch the religion for the given ID
  const getaboutquery = 'SELECT About FROM users WHERE id = ?';
  db.query(getaboutquery, [id], (err, results) => {
      if (err) {
          console.error('Error fetching About:', err.stack);
          res.status(500).json({ error: 'Error fetching About' });
          return;
      }
      if (results.length === 0) {
          res.status(404).json({ error: 'About not found for the given ID' });
          return;
      }
      const About = results[0].About;
      res.status(200).json({ About });
  });
});



// Endpoint for fetching height
app.get('/height', (req, res) => {
  const { id } = req.query;

  // Check if ID is provided
  if (!id) {
      res.status(400).json({ error: 'ID must be provided' });
      return;
  }

  // Query the database to fetch the height for the given ID
  const getHeightQuery = 'SELECT height FROM users WHERE id = ?';
  db.query(getHeightQuery, [id], (err, results) => {
      if (err) {
          console.error('Error fetching height:', err.stack);
          res.status(500).json({ error: 'Error fetching height' });
          return;
      }
      if (results.length === 0) {
          res.status(404).json({ error: 'Height not found for the given ID' });
          return;
      }
      const height = results[0].height;
      res.status(200).json({ height });
  });
});

// Endpoint for fetching date of birth (DOB)
app.get('/dob', (req, res) => {
  const { id } = req.query;

  // Check if ID is provided
  if (!id) {
      res.status(400).json({ error: 'ID must be provided' });
      return;
  }

  // Query the database to fetch the date of birth (DOB) for the given ID
  const getDobQuery = 'SELECT DATE_FORMAT(dob, "%Y-%m-%d") AS dob FROM users WHERE id = ?';
  db.query(getDobQuery, [id], (err, results) => {
      if (err) {
          console.error('Error fetching date of birth (DOB):', err.stack);
          res.status(500).json({ error: 'Error fetching date of birth (DOB)' });
          return;
      }
      if (results.length === 0) {
          res.status(404).json({ error: 'Date of birth (DOB) not found for the given ID' });
          return;
      }
      const dob = results[0].dob;
      res.status(200).json({ dob });
  });
});

// Endpoint for fetching hobbies
app.get('/hobbies', (req, res) => {
  const { id } = req.query;

  // Check if ID is provided
  if (!id) {
      res.status(400).json({ error: 'ID must be provided' });
      return;
  }

  // Query the database to fetch hobbies for the given ID
  const getHobbiesQuery = 'SELECT hobbies FROM users WHERE id = ?';
  db.query(getHobbiesQuery, [id], (err, results) => {
      if (err) {
          console.error('Error fetching hobbies:', err.stack);
          res.status(500).json({ error: 'Error fetching hobbies' });
          return;
      }
      if (results.length === 0) {
          res.status(404).json({ error: 'Hobbies not found for the given ID' });
          return;
      }
      const hobbiesJSON = results[0].hobbies;
      const hobbies = JSON.parse(hobbiesJSON);
      res.status(200).json({ hobbies });
  });
});










app.get('/edu', (req, res) => {
  const { id } = req.query;

  // Check if ID is provided
  if (!id) {
      res.status(400).json({ error: 'ID must be provided' });
      return;
  }

  // Query the database to fetch the religion for the given ID
  const getedu = 'SELECT Education FROM users WHERE id = ?';
  db.query(getedu, [id], (err, results) => {
      if (err) {
          console.error('Error fetching Education:', err.stack);
          res.status(500).json({ error: 'Error fetching Education' });
          return;
      }
      if (results.length === 0) {
          res.status(404).json({ error: 'Education not found for the given ID' });
          return;
      }
      const Education = results[0].Education;
      res.status(200).json({ Education });
  });
});




















app.get('/job', (req, res) => {
  const { id } = req.query;

  // Check if mobile number is provided
  if (!id) {
      res.status(400).json({ error: 'id must be provided' });
      return;
  }

  // Query the database to fetch the last name for the given mobile number
  const getjob = 'SELECT Profession FROM users WHERE id = ?';
  db.query(getjob, [id], (err, results) => {
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
  const { id } = req.query;

  // Check if mobile number is provided
  if (!id) {
      res.status(400).json({ error: 'id must be provided' });
      return;
  }

  // Query the database to fetch the last name for the given mobile number
  const getplace = 'SELECT Place_of_birth FROM users WHERE id = ?';
  db.query(getplace, [id], (err, results) => {
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
  const { id } = req.query;

  // Check if mobile number is provided
  if (!id) {
      res.status(400).json({ error: 'id must be provided' });
      return;
  }

  // Query the database to fetch the last name for the given mobile number
  const getsmoke = 'SELECT Smoke FROM users WHERE id = ?';
  db.query(getsmoke, [id], (err, results) => {
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
  const { id } = req.query;

  // Check if mobile number is provided
  if (!id) {
      res.status(400).json({ error: 'id must be provided' });
      return;
  }

  // Query the database to fetch the last name for the given mobile number
  const getdiet = 'SELECT Diet FROM users WHERE id = ?';
  db.query(getdiet, [id], (err, results) => {
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
  const { id } = req.query;

  // Check if mobile number is provided
  if (!id) {
      res.status(400).json({ error: 'id must be provided' });
      return;
  }

  // Query the database to fetch the last name for the given mobile number
  const getdrink = 'SELECT Drink FROM users WHERE id = ?';
  db.query(getdrink, [id], (err, results) => {
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




















app.get('/user/:userId', (req, res) => {
  const userId = req.params.userId;
  const sql = `
    SELECT firstName, lastName, DATE_FORMAT(dob, '%Y-%m-%d') AS dob, email, username, height, religion, gender, profileImage 
    FROM users 
    WHERE id = ?
  `;

  db.query(sql, [userId], (err, result) => {
    if (err) {
      console.error('Error fetching user:', err);
      res.status(500).json({ error: 'Error fetching user' });
      return;
    }

    if (result.length > 0) {
      const user = result[0];

      if (user.profileImage) {
        try {
          // Convert BLOB data to base64 string
          const imageData = Buffer.from(user.profileImage, 'binary').toString('base64');

          // Construct a data URL (e.g., "data:image/png;base64,...") for the image
          user.profileImage = `data:image/png;base64,${imageData}`;
        } catch (error) {
          console.error('Error converting image data:', error);
          res.status(500).json({ error: 'Error converting image data' });
          return;
        }
      } else {
        user.profileImage = null; // If no image data is found, return null for the profileImage
      }

      res.json(user); // Return the user details including the profile image
    } else {
      res.status(404).json({ message: 'User not found' });
    }
  });
});

  
// Start the server
const PORT = process.env.PORT || 3100;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
