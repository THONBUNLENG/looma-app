
const admin = require('firebase-admin');
const fs = require('fs');

/**
 * INSTRUCTIONS:
 * 1. Go to Firebase Console -> Project Settings -> Service Accounts.
 * 2. Click "Generate new private key".
 * 3. Save the JSON file as 'serviceAccountKey.json' in this directory.
 * 4. Run 'npm install firebase-admin'
 * 5. Run 'node upload_to_firestore.js'
 */

const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function uploadData() {
  const data = JSON.parse(fs.readFileSync('./all_data.json', 'utf8'));

  for (const collectionName in data) {
    console.log(`Uploading collection: ${collectionName}...`);
    const collectionData = data[collectionName];

    if (Array.isArray(collectionData)) {
      const batch = db.batch();

      collectionData.forEach((docData, index) => {
        // If the item doesn't have an ID, Firestore will auto-generate one
        // or we can use a stringified index if we want order
        const docRef = db.collection(collectionName).doc();
        batch.set(docRef, docData);
      });

      await batch.commit();
      console.log(`Successfully uploaded ${collectionData.length} items to ${collectionName}.`);
    } else {
      // For objects that aren't lists (if any)
      await db.collection('metadata').doc(collectionName).set(collectionData);
      console.log(`Uploaded ${collectionName} as a single document in 'metadata'.`);
    }
  }

  print('All uploads completed!');
}

uploadData().catch(console.error);
