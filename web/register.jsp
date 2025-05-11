<%-- 
    Document   : register
    Created on : May 5, 2025, 5:45:37 PM
    Author     : kay
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Zenijah - Register</title>
  <link rel="stylesheet" href="main.css" />
</head>
<body class="dashboard">
  <header class="dashboard-header">
    <h1>📝 Zenijah Registration</h1>
    <nav>
      <a href="index.jsp">Home</a>
      <a href="login.jsp">Login</a>
    </nav>
  </header>

  <main class="dashboard-container">
    <div class="card">
      <h2>Create an Account</h2>

      <%-- Display registration error if exists --%>
      <%
        String error = request.getParameter("error");
        if (error != null) {
      %>
        <p style="color: red;"><%= error %></p>
      <% } %>

<form action="register" method="POST">
  <input type="text" name="username" placeholder="Username" required class="input-field"><br>
  <input type="email" name="email" placeholder="Email" required class="input-field"><br>
  <input type="password" name="password" placeholder="Password" required class="input-field"><br>
  <input type="number" name="age" placeholder="Age" required class="input-field" min="1"><br>
  <input type="date" name="dob" placeholder="Date of Birth" required class="input-field"><br>
  <button type="submit" class="btn">Register</button>
</form>

    </div>
  </main>

  <footer>
    <p>&copy; 2025 Zenijah. Unleash Your Creativity 💫</p>
  </footer>
</body>
</html>
