# Matrimonial App

## Overview

The Matrimonial App is a platform developed using Flutter for the frontend and Node.js with Socket.IO for the backend. This app provides users with features to post testimonials and blogs, like profiles, and chat with other users. During signup, the app collects various details from the user, including mobile number, email, name, gender, profession, diet, smoking habits, and more.

## Features

- **User Signup**: Collects essential details such as mobile number, email, name, gender, profession, diet, smoking habits, etc.
- **Profile Liking**: Users can like other profiles, facilitating potential matches.
- **Post Testimonials and Blogs**: Users can share their experiences and thoughts through testimonials and blogs.
- **Chat Feature**: Real-time messaging between users using Socket.IO.

## Technologies Used

### Frontend
- **Flutter**: A UI toolkit for crafting natively compiled applications for mobile from a single codebase.
- **Dart**: The programming language used with Flutter to build the app.

### Backend
- **Node.js**: A JavaScript runtime built on Chrome's V8 JavaScript engine for building fast and scalable network applications.
- **Socket.IO**: A library that enables real-time, bidirectional, and event-based communication.

## Installation and Setup

### Prerequisites
- Flutter SDK
- Dart SDK
- Node.js
- npm (Node Package Manager)

### Frontend Setup
1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/matrimonial-app.git
   cd matrimonial-app/frontend
2. **Install Dependencies**
  ```bash
  flutter pub get
3. **Run the App**
  ```bash
  flutter pub get

### Backend Setup
1.**Clone the Repository**
  ```bash
  git clone https://github.com/your-username/matrimonial-app.git
  cd matrimonial-app/backend
2.**Install Dependencies**
  ```bash
  npm install
3.**Run the Server**
  ```bash
  node server.js


###File Structure
 **Frontend (Flutter)**
    matrimonial-app/
  ├── frontend/
  │   ├── lib/
  │   │   ├── main.dart
  │   │   ├── screens/
  │   │   ├── widgets/
  │   ├── assets/
  │   ├── pubspec.yaml
  ├── backend/

**Backend (Node.js)**
  matrimonial-app/
  ├── backend/
  │   ├── server.js
  │   ├── routes/
  │   ├── models/
  │   ├── controllers/
  │   ├── socket/



###Features in Detail
1.**User Signup**
  **Fields Collected**: Mobile number, email, name, gender, profession, diet, smoking habits, etc.
  **Validation**: Ensures all required fields are filled and valid.
2.**Profile Liking**
    Users can browse through profiles and like them to show interest.
    Notifications can be sent to users when their profile is liked.
3.**Post Testimonials and Blogs**
    Users can write and post testimonials about their experiences.
    Users can also write blogs and share them with the community.
4.**Chat Feature**
    Real-time messaging powered by Socket.IO.
    Users can chat privately with other users they are interested in.


###Contribution
Contributions are welcome! Please fork the repository and create a pull request with your changes. For major changes, please open an issue first to discuss what you would like to change.

###License
This project is licensed under the MIT License. See the LICENSE file for more details.



