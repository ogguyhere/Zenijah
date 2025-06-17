<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String email = (String) session.getAttribute("email");
    String name = (String) session.getAttribute("username");
    Integer age = (Integer) session.getAttribute("age");
    java.sql.Date dob = (java.sql.Date) session.getAttribute("dob");

    if (email == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Update Profile - Zenijah</title>
  <link rel="stylesheet" href="main.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
  <style>
    .dashboard-container {
      max-width: 600px;
      margin: 40px auto;
    }
    .card label {
      color: #fff;
      font-weight: 600;
      display: block;
      margin-top: 15px;
    }
    .card input {
      width: 100%;
      padding: 10px;
      margin-top: 5px;
      border-radius: 8px;
      border: 1px solid #ccc;
    }
    .btn {
      margin-top: 20px;
      padding: 10px 15px;
      background-color: #d63384;
      color: white;
      border: none;
      border-radius: 8px;
      font-weight: bold;
      cursor: pointer;
    }
    .btn:hover {
      background-color: #ad2066;
    }
    .btn.delete {
      background-color: crimson;
    }
    .btn.delete:hover {
      background-color: darkred;
    }
    #result {
      text-align: center;
      margin-top: 15px;
      font-weight: 600;
    }
  </style>
</head>
<body class="dashboard">

  <header class="dashboard-header">
    <h1>👤 Zenijah</h1>
    <nav>
      <a href="user-dashboard.jsp">Dashboard</a>
      <a href="logout.jsp">Logout</a>
    </nav>
  </header>

  <main class="dashboard-container">
      <h1 align='center'>Update Your Profile</h1>
    <div class="card">
      <form id="updateForm">
        <label>Name:</label>
        <input type="text" name="name" value="<%= name != null ? name : "" %>" required>

        <label>Age:</label>
        <input type="number" name="age" value="<%= age != null ? age : "" %>" required>

        <label>Date of Birth:</label>
        <input type="date" name="dob" value="<%= dob != null ? dob.toString() : "" %>" required>

        <button type="submit" class="btn">Update Profile</button>
      </form>

      <button id="deleteBtn" class="btn delete">Delete Account</button>
      <p id="result"></p>
    </div>
  </main>

  <footer style="text-align:center; margin-top: 60px;">
    &copy; 2025 <strong>Zenijah</strong>. Made with 💖 by Khadijah.
  </footer>

  <script>
    const form = document.getElementById("updateForm");
    const resultEl = document.getElementById("result");

    form.addEventListener("submit", async (e) => {
      e.preventDefault();

      const formData = new FormData(form);
      const jsonData = {
        name: formData.get("name").trim(),
        age: parseInt(formData.get("age")),
        dob: formData.get("dob")
      };

      try {
        const res = await fetch("api/profile", {
          method: "PUT",
          headers: { "Content-Type": "application/json" },
          credentials: "include",
          body: JSON.stringify(jsonData)
        });

        const data = await res.json();
        if (data.status === "updated") {
          resultEl.innerText = "✅ Profile Updated!";
          resultEl.style.color = "limegreen";
          setTimeout(() => location.reload(), 1000);
        } else {
          resultEl.innerText = data.error || "❌ Update Failed";
          resultEl.style.color = "red";
        }
      } catch (error) {
        resultEl.innerText = "❌ Network Error";
        resultEl.style.color = "red";
      }
    });

    document.getElementById("deleteBtn").addEventListener("click", async () => {
      if (!confirm("Are you sure you want to delete your account? This cannot be undone!")) return;

      try {
        const res = await fetch("api/profile", {
          method: "DELETE",
          credentials: "include"
        });

        const data = await res.json();
        if (data.status === "account deleted") {
          alert("✅ Account Deleted!");
          window.location.href = "logout.jsp";
        } else {
          alert(data.error || "❌ Deletion Failed");
        }
      } catch (error) {
        alert("❌ Network Error");
      }
    });
  </script>
</body>
</html>
