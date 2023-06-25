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
      const payload = {
        notification: {
          title: "New Preorder!",
          body: "TESTING",
        },
      };
      const tokens = ["dbqSVGn-zUyRs7_WWwFRXU:APA91bG9lyDVDMZOajiKWIYqc2nzLm1FcxoTasG9DtDnEgbBuRWPmvWwyGFjXmlz8HNInRAZrzd2m5MGUyWXwOm4pfg0Gm7c9R1a5MKA09nCX_DHMnTqqhTCFoItcZ1TY7irjSDHlR2J"];
      /* eslint-disable*/
      const response = await admin.messaging().sendToDevice(tokens, payload);
      console.log("Message sent successfully:", response); 
      console.log(response.results[0].error);
      console.log("shit");

      return null;
    // } catch (error) {
    //   console.error(error);
    //   throw new functions.https.HttpsError("internal", "Something went wrong");
    // }
  });