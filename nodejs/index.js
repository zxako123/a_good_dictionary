const express = require('express');
const app = express();
const { MongoClient } = require('mongodb');

const uri = 'mongodb+srv://long:135792@dictionary.lvf694h.mongodb.net/'; // Replace with your MongoDB connection string
const dbName = 'dictionary';
const englishCollectionName = 'english';
const vietnameseCollectionName = 'vietnamese';

async function connectToMongoDB() {
  const client = new MongoClient(uri);
  try {
    await client.connect();
    console.log('Connected to MongoDB');

    const db = client.db(dbName);
    return db;
  } catch (error) {
    console.error('Error connecting to MongoDB', error);
  }
}

app.get('/english', async (req, res) => {
  try {
    const db = await connectToMongoDB();
    const collection = db.collection(englishCollectionName);

    const entries = await collection.find().toArray();
    res.json(entries);
  } catch (error) {
    console.error('Error retrieving English dictionary entries', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/vietnamese', async (req, res) => {
  try {
    const db = await connectToMongoDB();
    const collection = db.collection(vietnameseCollectionName);

    const entries = await collection.find().toArray();
    res.json(entries);
  } catch (error) {
    console.error('Error retrieving Vietnamese dictionary entries', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.listen(8000, () => {
  console.log('Server listening on port 8000');
});