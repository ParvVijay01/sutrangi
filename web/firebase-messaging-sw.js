importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyAywlkoQC7K1E1y0KUBpnWQIiGfKNbHyPk",
    authDomain: "sutrangi-50204.firebaseapp.com",
    projectId: "sutrangi-50204",
    storageBucket: "sutrangi-50204.firebasestorage.app",
    messagingSenderId: "371108628847",
    appId: "1:371108628847:web:729a6d5b9c88341b7a809a",
    measurementId: "G-8KR3JCMZHH"
});

const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            const title = payload.notification.title;
            const options = {
                body: payload.notification.score
              };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});