# Matrimonial App

Welcome to our Matrimonial App! This application is designed to help individuals find their life partners through a user-friendly platform. It is built with Flutter and Dart for the frontend, and Node.js with Socket.io for the backend.

## Features

- **User Registration**: Users can sign up by providing their mobile number, email, name, gender, profession, diet preferences, smoking habits, and other relevant details.
- **User Profiles**: Browse and like profiles of other users.
- **Testimonials and Blogs**: Users can post testimonials and read blogs.
- **Chat Feature**: Real-time messaging between users using Socket.io.
- **Profile Likes**: Users can like the profiles they are interested in.

## Getting Started

### Prerequisites

Ensure you have the following software installed:

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)
- [Node.js](https://nodejs.org/)
- [npm](https://www.npmjs.com/)

### Installation

1. **Clone the repository:**

    ```bash
    git clone https://github.com/yourusername/matrimonial-app.git
    cd matrimonial-app
    ```

2. **Frontend Setup (Flutter):**

    - Navigate to the `frontend` directory:

        ```bash
        cd frontend
        ```

    - Install the dependencies:

        ```bash
        flutter pub get
        ```

    - Run the Flutter app:

        ```bash
        flutter run
        ```

3. **Backend Setup (Node.js):**

    - Navigate to the `backend` directory:

        ```bash
        cd ../backend
        ```

    - Install the dependencies:

        ```bash
        npm install
        ```

    - Start the Node.js server:

        ```bash
        npm start
        ```

## Usage

1. **User Registration**: Sign up by providing your details including mobile number, email, name, gender, profession, diet, smoking habits, and others.
2. **Browse Profiles**: Look through profiles of other users and like the ones you are interested in.
3. **Post Testimonials and Blogs**: Share your experiences and read what others have to say.
4. **Real-time Chat**: Use the chat feature to communicate with other users in real-time.

## Project Structure

```plaintext
matrimonial-app/
├── frontend/           # Flutter frontend code
│   ├── lib/
│   └── pubspec.yaml
├── backend/            # Node.js backend code
│   ├── controllers/
│   ├── models/
│   ├── routes/
│   ├── app.js
│   └── package.json
└── README.md


