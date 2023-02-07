importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

firebase.initializeApp({
    apiKey: "AIzaSyBBFxwS0P8MyMI1sWPAZj-MGpJgIDypru4",
    authDomain: "muserpol-pvt-9d002.firebaseapp.com",
    projectId: "muserpol-pvt-9d002",
    storageBucket: "muserpol-pvt-9d002.appspot.com",
    messagingSenderId: "187989256881",
    appId: "1:187989256881:web:6523a418dba9f36fbc1090",
    measurementId: "G-LQZN649LWC",
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// // Optional:
// messaging.onBackgroundMessage((message) => {
//   console.log("onBackgroundMessage", message);
// });
messaging.onBackgroundMessage(function(payload) {
  console.log('Received background message ', payload);

  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
  };

  self.registration.showNotification(notificationTitle,
    notificationOptions);
});