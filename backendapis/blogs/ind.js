const express = require('express');
const bodyParser = require('body-parser');
const multer = require('multer');
const cloudinary = require('cloudinary').v2;
const mysql = require('mysql2');

const app = express();
const port = 3500;

// Multer configuration for handling image uploads
const upload = multer({ dest: 'uploads/' }); // Assuming you are using multer for file uploads


// Configure Cloudinary with your Cloudinary credentials
cloudinary.config({
  cloud_name: 'dxvii6qjr',
  api_key: '224145425268199',
  api_secret: 'NL1VGgK5xmy17nnL6Et6T5N0DPA'
});

// Create MySQL connection
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'friend_requests_database'
  });

// Middleware
app.use(bodyParser.json());


// API endpoint for uploading data
app.post('/upload', upload.array('images', 3), async (req, res) => {
  try {
    const { username, text, videoUrl } = req.body;
    const imageFiles = req.files; // Extract image files

    // Check if image files were uploaded
    if (!imageFiles || imageFiles.length === 0) {
      return res.status(400).json({ error: 'Image files are required' });
    }

    // Upload images to Cloudinary with a tag
    const uploadPromises = imageFiles.map((file) => {
      return new Promise((resolve, reject) => {
        cloudinary.uploader.upload(file.path, { tags: [username, 'all'] }, (error, result) => {
          if (error) {
            console.error('Error uploading image to Cloudinary:', error);
            reject(error);
          } else {
            resolve(result.secure_url);
          }
        });
      });
    });

    Promise.all(uploadPromises)
      .then((imageUrls) => {
        // Store image URLs, username, and text in MySQL
        let query = 'INSERT INTO posted (username, text, video_url';
        let placeholders = '?,?,?';
        let queryParams = [username, text, videoUrl];
        
        for (let i = 0; i < imageUrls.length; i++) {
          query += `, image_url${i + 1}`;
          placeholders += ',?';
          queryParams.push(imageUrls[i]);
        }
        
        query += `) VALUES (${placeholders})`;
        
        connection.query(query, queryParams, (err, results) => {
          if (err) {
            console.error('Error storing data in MySQL:', err);
            return res.status(500).json({ error: 'Failed to store data' });
          }

          res.status(200).json({ message: 'Data uploaded successfully', imageUrls });
        });
      })
      .catch((error) => {
        console.error('Internal Server Error:', error);
        res.status(500).json({ error: 'Internal Server Error' });
      });
  } catch (error) {
    console.error('Internal Server Error:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


// GET API endpoint to retrieve details of all users
app.get('/users', (req, res) => {
    try {
      // Query to select all rows from the posted table
      const query = 'SELECT * FROM posted';
  
      // Execute the query
      connection.query(query, (err, results) => {
        if (err) {
          console.error('Error fetching user details:', err);
          return res.status(500).json({ error: 'Failed to fetch user details' });
        }
  
        // Return the results
        res.status(200).json({ users: results });
      });
    } catch (error) {
      console.error('Internal Server Error:', error);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  });
  
// Start the server
app.listen(port, () => {
  console.log(`Server is listening on port ${port}`);
});