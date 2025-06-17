<%-- 
    Document   : login
    Created on : May 5, 2025, 5:43:19 PM
    Author     : kay
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Zenijah - Login</title>
  <link rel="stylesheet" href="main.css" />
</head>
<body class="dashboard">
  <header class="dashboard-header">
    <h1>🔐 Zenijah Login</h1>
    <nav>
      <a href="index.jsp">Home</a>
      <a href="register.jsp">Register</a>
    </nav>
  </header>
    <br><br><br><br><br><br><br><br><br>
  <main class="dashboard-container">
       
    <div class="card">
      <h2 style = "color: white"> Welcome Back Artist!</h2>

      <%-- Display login error if exists --%>
      <%
        String error = request.getParameter("error");
        if (error != null) {
      %>
        <p style="color: red;"><%= error %></p>
      <% } %>

      <form action="login" method="POST">
        <input type="email" name="email" placeholder="Email" required class="input-field"><br>
        <input type="password" name="password" placeholder="Password" required class="input-field"><br>
        <button type="submit" class="btn">Login</button>
      </form>
    </div>
  </main>
        <br><br><br><br><br><br><br><br><br><br><br>

  <footer>
    <p>&copy; 2025 Zenijah. Secure and Stylish ✨</p>
  </footer>
</body>
</html>
