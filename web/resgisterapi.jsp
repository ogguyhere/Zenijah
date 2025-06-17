<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Register Students - Zenijah</title>
  <link rel="stylesheet" href="main.css" />
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
  <style>
    .form-container {
      max-width: 700px;
      margin: auto;
      background: white;
      padding: 30px;
      border-radius: 15px;
      box-shadow: 0 5px 20px rgba(0,0,0,0.1);
    }

    label {
      display: block;
      margin: 15px 0 5px;
      font-weight: bold;
    }

    input {
      width: 100%;
      padding: 10px;
      border-radius: 8px;
      border: 1px solid #ccc;
    }

    .btn-group {
      margin-top: 20px;
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
    }

    .btn {
      padding: 10px 15px;
      background-color: #d63384;
      color: white;
      border: none;
      border-radius: 8px;
      text-decoration: none;
      font-weight: bold;
      cursor: pointer;
      transition: 0.3s ease;
    }

    .btn:hover {
      background-color: #ad2066;
    }

    pre {
      background: #f8f9fa;
      padding: 15px;
      border-radius: 10px;
      margin-top: 30px;
      max-height: 300px;
      overflow-y: auto;
    }

    h2 {
      margin-top: 40px;
    }

    .centered {
      text-align: center;
    }
  </style>

  <script type="text/javascript">
  //<![CDATA[
    let lastJsonResponse = null;

    async function registerStudents() {
      const students = [{
        name: document.getElementById("name").value,
        email: document.getElementById("email").value,
        password: document.getElementById("password").value,
        age: parseInt(document.getElementById("age").value),
        dob: document.getElementById("dob").value
      }];

      const res = await fetch('api/students', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(students)
      });

      const data = await res.json();
      showResponse(data);
    }

    async function getAllStudents() {
      const res = await fetch('api/students');
      const data = await res.json();
      showResponse(data);
    }

    async function updateStudent() {
      const updateData = {
        email: document.getElementById("email").value,
        name: document.getElementById("name").value,
        age: parseInt(document.getElementById("age").value),
        dob: document.getElementById("dob").value
      };

      const res = await fetch('api/students', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(updateData)
      });

      const data = await res.json();
      showResponse(data);
    }

    async function deleteStudent() {
      const email = document.getElementById("email").value;
      const res = await fetch("api/students?email=" + encodeURIComponent(email), {
        method: 'DELETE'
      });

      const data = await res.json();
      showResponse(data);
    }

    function showResponse(data) {
      lastJsonResponse = data;
      document.getElementById("output").innerText = JSON.stringify(data, null, 2);
    }

    function downloadJSON() {
      if (!lastJsonResponse) {
        alert("No data available to download yet!");
        return;
      }

      const blob = new Blob([JSON.stringify(lastJsonResponse, null, 2)], { type: 'application/json' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement("a");
      a.href = url;
      a.download = "students.json";
      a.click();
      URL.revokeObjectURL(url);
    }

    async function bulkAction(method) {
      const fileInput = document.getElementById("jsonFile");
      const file = fileInput.files[0];

      if (!file) {
        alert("Please upload a JSON file first.");
        return;
      }

      const text = await file.text();
      let students;
      try {
        students = JSON.parse(text);
        if (!Array.isArray(students)) throw new Error();
      } catch (e) {
        alert("Invalid JSON format! Expected an array of student objects.");
        return;
      }

      if (method === 'DELETE') {
        let results = [];
        for (let s of students) {
          if (!s.email) continue;
          try {
            const url = "api/students?email=" + encodeURIComponent(s.email);
            const res = await fetch(url, {
              method: 'DELETE'
            });
            const data = await res.json();
            results.push(data);
          } catch (err) {
            results.push({ error: true, message: "Failed to delete " + s.email });
          }
        }
        showResponse(results);
      } else {
        try {
          const res = await fetch('api/students', {
            method: method,
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(students)
          });
          const data = await res.json();
          showResponse(data);
        } catch (e) {
          showResponse({ error: true, message: 'Bulk request failed.' });
        }
      }
    }
  //]]>
  </script>
</head>

<body class="dashboard">
  <header class="dashboard-header">
    <h1>📋 Register Students</h1>
    <nav>
      <a href="admin-dashboard.jsp">Dashboard</a>
      <a href="logout.jsp">Logout</a>
    </nav>
  </header>

  <div class="form-container">
    <label>Name</label>
    <input type="text" id="name" />

    <label>Email</label>
    <input type="email" id="email" />

    <label>Password</label>
    <input type="password" id="password" />

    <label>Age</label>
    <input type="number" id="age" />

    <label>Date of Birth</label>
    <input type="date" id="dob" />

    <div class="btn-group">
      <button class="btn" onclick="registerStudents()">Register (POST)</button>
      <button class="btn" onclick="getAllStudents()">Get All (GET)</button>
      <button class="btn" onclick="updateStudent()">Update (PUT)</button>
      <button class="btn" onclick="deleteStudent()">Delete (DELETE)</button>
      <button class="btn" onclick="downloadJSON()">⬇️ Download JSON</button>
    </div>

    <hr>
    <h2>📁 Bulk Operation from JSON</h2>
    <label for="jsonFile">Upload JSON File</label>
    <input type="file" id="jsonFile" accept=".json" />

    <div class="btn-group">
      <button class="btn" onclick="bulkAction('POST')">Bulk Register</button>
      <button class="btn" onclick="bulkAction('PUT')">Bulk Update</button>
      <button class="btn" onclick="bulkAction('DELETE')">Bulk Delete</button>
    </div>

    <p style="margin-top: 10px; font-size: 0.9em; color: #555;">
      <strong>Sample format:</strong><br/>
      <code>[
        {"name": "Ali", "email": "ali@example.com", "password": "123", "age": 20, "dob": "2005-05-12"},
        {"name": "Sara", "email": "sara@example.com", "password": "456", "age": 22, "dob": "2003-09-25"}
      ]</code>
    </p>

    <h2>API Response</h2>
    <pre id="output">{}</pre>
  </div>

  <footer class="centered" style="margin-top: 60px;">
    &copy; 2025 <strong>Zenijah</strong>. Made with 💖 by Khadijah.
  </footer>
</body>
</html>
