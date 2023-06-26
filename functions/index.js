const functions = require('firebase-functions');
const admin = require('firebase-admin');

var serviceAccount = require("../dinetime-mvp-364902-firebase-adminsdk-dpzss-bea2fed8c3.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://dinetime-mvp-364902-default-rtdb.firebaseio.com"
});



exports.sendPreorderNotification = functions.firestore
    .document("preorders/{documentId}")
    .onCreate(async (snapshot) => {
    //   try {
    //     console.log("Received");
    //     const newValue = snapshot.data();
    //     const restaurantRef = admin.firestore().doc(newValue.restaurant_ref);
    //     /* eslint-disable*/
    //     const owners = admin.firestore().collection("owners").where("restaurant_refs", "==", restaurantRef);
    //     const tokens = [];
    //     owners.get().then((ownerSnapshot) => {
    //     ownerSnapshot.forEach((owner)=>{
    //       tokens.push(owner.data().token);
    //     });
    //   });
    //   /* eslint-disable*/
    //   let message = "";
    //   const preorderItemsRef = admin.firestore().collection("preorders").doc(snapshot.id).collection('items');
    //   preorderItemsRef.get().then((itemSnapshot) =>{
    //     itemSnapshot.forEach((doc) => {
    //       // look up query
    //       const itemRef = doc.data().menu_item_ref;
    //       const num = doc.data().quantity;
    //       message += num.toString() + " " + itemRef.get().item_name + "\n";
    //     })
    //   })

      // Send message using Firebase Cloud Messaging
      // var test = snapshot.data()
      // var custRef = test.customer_ref;
      // console.log(typeof(custRef));
      // var testData = await custRef.get();
      // console.log(testData.data().token);
      const payload = {
        notification: {
          title: "New Preorder!",
          body: "TESTING",
        },
        token: "cR_ci6z1RbyyvZkOTP4AuP:APA91bEJhg-EqTLdImiipjd-wpHvFXQOBDIvUAXQ-FXei2ZjWoRYU4yS1cH-4cV3gZqfk98kKlVGwstA7QfZns-jHLhRaRD8OsAgijVd_XuJC0vC72-BQApX2yCE3TcgyTTppJwXuN-u",
      };
      /* eslint-disable*/
      const response = await admin.messaging().send(payload);
      console.log("Message sent successfully:", response); 
      return null;
    // } catch (error) {
    //   console.error(error);
    //   throw new functions.https.HttpsError("internal", "Something went wrong");
    // }
  });