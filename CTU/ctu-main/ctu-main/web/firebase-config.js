// Firebase configuration for web
const firebaseConfig = {
  apiKey: "AIzaSyC3fxA9s9WuJkLj3TsIjqPTKS0AEjPYETM",
  authDomain: "ctu-smart-school-calendar.firebaseapp.com",
  projectId: "ctu-smart-school-calendar",
  storageBucket: "ctu-smart-school-calendar.firebasestorage.app",
  messagingSenderId: "504460775226",
  appId: "1:504460775226:web:40aa281ade3dc47f754a03",
  measurementId: "G-1Y6R2B8XBB"
};

// Initialize Firebase
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, signOut, onAuthStateChanged } from "firebase/auth";

const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
const auth = getAuth(app);

export { app, analytics, auth, signInWithEmailAndPassword, createUserWithEmailAndPassword, signOut, onAuthStateChanged };
