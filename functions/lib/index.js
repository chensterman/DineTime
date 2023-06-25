"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendPreorderNotification = void 0;
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
exports.sendPreorderNotification = functions.firestore
    .document("preorders/{documentId}")
    .onCreate(async (snapshot) => {
    try {
        console.log("Received");
        const newValue = snapshot.data();
        const restaurantRef = admin.firestore().doc(newValue.restaurant_ref);
        /* eslint-disable*/
        const owners = admin.firestore().collection("owners").where("restaurant_refs", "==", restaurantRef);
        const tokens = [];
        owners.get().then((ownerSnapshot) => {
            ownerSnapshot.forEach((owner) => {
                tokens.push(owner.data().token);
            });
        });
        /* eslint-disable*/
        let message = "";
        const preorderItemsRef = admin.firestore().collection("preorders").doc(snapshot.id).collection('items');
        preorderItemsRef.get().then((itemSnapshot) => {
            itemSnapshot.forEach((doc) => {
                // look up query
                const itemRef = doc.data().menu_item_ref;
                const num = doc.data().quantity;
                message += num.toString() + " " + itemRef.get().item_name + "\n";
            });
        });
        // Send message using Firebase Cloud Messaging
        const payload = {
            notification: {
                title: "New Preorder!",
                body: message,
                data: { "type": "preorder" }
            },
            tokens: tokens,
        };
        /* eslint-disable*/
        const response = await admin.messaging().sendMulticast(payload);
        console.log("Message sent successfully:", response);
        return null;
    }
    catch (error) {
        console.error(error);
        throw new functions.https.HttpsError("internal", "Something went wrong");
    }
});
//# sourceMappingURL=index.js.map