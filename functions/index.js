const functions = require('firebase-functions');
const admin = require('firebase-admin');

var serviceAccount = require("../dinetime-mvp-364902-firebase-adminsdk-dpzss-bea2fed8c3.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://dinetime-mvp-364902-default-rtdb.firebaseio.com"
});

exports.sendPreorderCreatedNotification = functions.firestore
    .document("preorders/{documentId}")
    .onCreate(async (snapshot) => {
      try {
        const newValue = snapshot.data();
        const restaurantRef = newValue.restaurant_ref;

        const owners = admin.firestore().collection("owners").where("restaurant_refs", "array_contains", restaurantRef);
        const tokens = [];
        owners.get().then((ownerSnapshot) => {
        ownerSnapshot.forEach((owner)=>{
          tokens.push(owner.data().token);
        });
      });

      // let message = "";
      // const preorderItemsRef = admin.firestore().collection("preorders").doc(snapshot.id).collection('items');
      // preorderItemsRef.get().then((itemSnapshot) =>{
      //   itemSnapshot.forEach((doc) => {
      //     // look up query
      //     const itemRef = doc.data().menu_item_ref;
      //     const num = doc.data().quantity;
      //     message += num.toString() + " " + itemRef.get().item_name + "\n";
      //   })
      // })

      const payload = {
        notification: {
          title: "New Preorder!",
          body: "TESTING",
        },
        tokens: tokens,
      };

      const response = await admin.messaging().sendEachForMulticast(payload)
      console.log("Message sent successfully:", response); 
      return null;
    } catch (error) {
      console.error(error);
      throw new functions.https.HttpsError("internal", "Something went wrong");
    }
  });

  exports.sendPreorderCompletedNotification = functions.firestore
    .document("preorders/{documentId}")
    .onUpdate(async (change, context) => {
      var prevData = change.before.data()
      var currData = change.after.data()
      if (prevData.fulfilled == false && currData.fulfilled == true) {
        console.log("here");
        var customerSnapshot = await currData.customer_ref.get()

        const payload = {
          notification: {
            title: "New Preorder!",
            body: "TESTING",
          },
          token: customerSnapshot.data().token,
        };

        const response = await admin.messaging().send(payload)
        console.log("Message sent successfully:", response); 
      }
      return null;
  });