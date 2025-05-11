<%-- 
    Document   : admin-dashboard
    Created on : May 5, 2025, 5:37:00 PM
    Author     : kay
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String email = (String) session.getAttribute("email");
    Boolean isAdmin = (Boolean) session.getAttribute("is_admin");

    if (email == null || isAdmin == null || !isAdmin) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Admin Dashboard - Zenijah</title>
  <link rel="stylesheet" href="main.css" />
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
</head>
<body class="dashboard">
  <header class="dashboard-header">
    <h1>👑 Zenijah Admin</h1>
    <nav>
      <a href="index.jsp">Home</a>
      <a href="gallery.jsp">Gallery</a>
      <a href="logout.jsp">Logout</a>
    </nav>
  </header>

  <div class="dashboard-container">
    <div class="card">
      <h2 style = "color:white">Welcome, Admin <%= email %>!</h2>
     

      <!-- Action Buttons -->
      <div style="margin-top: 20px;">
        <a href="admin-view-submissions.jsp" class="btn">📥 View All Submissions</a>
        <br><br><br><br>
        <a href="admin-upload-challenge.jsp" class="btn">📤 Upload New Challenge</a>
        <br><br><br><br>
        <a href ="admin-upload-doodle.jsp" class ="btn" >Upload New Doodle </a>
        <br><br><br><br>
      </div>
    </div>
      
      <br><br><br>

    <div class="card">
      <h2>📊 Platform Stats</h2>
      <p>Total Users: <strong>123</strong></p>
      <p>Artwork Uploaded: <strong>256</strong></p>
    </div>
  </div>

  <footer>
    &copy; 2025 <strong>Zenijah</strong>. Made with 🖤 & 🎨 by Khadijah.
  </footer>
</body>
</html>
