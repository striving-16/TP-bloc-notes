# TP-bloc-notes

A clean and modern **Bloc-Notes (Notes App)** built with Flutter.
This project demonstrates state management using both **setState** and **Provider**, following a progressive and scalable architecture.

---

## 🚀 Features

* ✏️ Create, edit, and delete notes (CRUD)
* 🎨 Assign custom colors to each note
* 🔍 Real-time search (title & content)
* 📊 Sort notes (date, alphabetical)
* 🕒 Display creation & modification dates
* 📱 Clean and responsive UI
* ⚡ Smooth navigation between screens

---

## 🧠 Learning Objectives

This project was designed to master:

* Stateful widgets & UI updates with `setState`
* Navigation with `Navigator.push` / `pop`
* Passing data between screens
* Form handling & validation
* State management with **Provider**
* Clean architecture (separation of concerns)

---

## 🏗️ Project Structure

```
lib/
├── main.dart
├── models/
│   └── note.dart
├── services/
│   └── note_service.dart
├── pages/
│   ├── home_page.dart
│   ├── create_page.dart
│   └── detail_page.dart
```

---

## 🔄 State Management

### 🟡 Part 1 — setState

* Local state inside widgets
* Simple and direct updates
* Used for basic CRUD operations

### 🔵 Part 2 — Provider

* Global state management
* `ChangeNotifier` for reactive updates
* Clean separation between UI and logic

---

## 🔁 Navigation Flow

```
Home → Create Note → Detail Note → Edit Note
```

* `Navigator.push()` to open screens
* `Navigator.pop()` to return data

---

## ⚙️ Technologies Used

* Flutter (Dart)
* Provider (State Management)
* Material UI

---

## 💡 Key Concepts

* `StatefulWidget`
* `setState()`
* `ChangeNotifier`
* `Consumer`
* `context.watch()` / `context.read()`

---

## 📈 Advanced Features

* 🔎 Search notes dynamically
* 📊 Sorting system (date & title)
* 🔢 Live note counter in AppBar
* 🎨 Animated color selector

---

## 🧪 Future Improvements

* 💾 Local storage (SQLite / Hive)
* ☁️ Cloud sync (Firebase)
* 🔐 Authentication
* 🏷️ Categories / tags
* 🌙 Dark mode

---

## 📌 Conclusion

This project highlights the transition from **basic state management (setState)** to a more **scalable architecture using Provider**.
It demonstrates best practices for building clean, maintainable Flutter applications.

---

