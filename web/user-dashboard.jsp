<%-- 
    Document   : user-dashboard
    Created on : May 5, 2025, 5:37:33 PM
    Author     : kay
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String email = (String) session.getAttribute("email");
    Boolean isAdmin = (Boolean) session.getAttribute("is_admin");
    String username = (String) session.getAttribute("username");
    java.sql.Date dob = (java.sql.Date) session.getAttribute("dob");

    // Redirect if not logged in or if admin
    if (email == null || (isAdmin != null && isAdmin)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Debug: Print DOB to server log
    System.out.println("User DOB from session: " + dob);

    // Birthday check
    boolean isBirthday = false;
    if (dob != null) {
        java.time.LocalDate today = java.time.LocalDate.now();
        java.time.MonthDay currentMonthDay = java.time.MonthDay.from(today);
        java.time.MonthDay dobMonthDay = java.time.MonthDay.from(dob.toLocalDate());
        isBirthday = currentMonthDay.equals(dobMonthDay);
         System.out.println("Today: " + today);
    System.out.println("DOB MonthDay: " + dobMonthDay);
    System.out.println("Is Birthday: " + isBirthday);
    }
    
 
%>

   <script>
  console.log("DOB from session: <%= dob != null ? dob.toString() : "null" %>");
</script>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>User Dashboard - Zenijah</title>
  <link rel="stylesheet" href="main.css" />
</head>
<body class="dashboard">
  <header class="dashboard-header">
    <h1>Zenijah</h1>
    <nav>
      <a href="index.jsp">Home</a>
      <a href="gallery.jsp">Gallery</a>
      <a href="logout.jsp">Logout</a>
    </nav>
  </header>

  <div class="dashboard-container">
    <% if (isBirthday) { %>
      <div class="card" style="background-color: #fff0f5;">
        <h2>🎉 Happy Birthday, <%= username != null ? username : "User" %>! 🎂</h2>
        <p>We wish you a creative and joyful year ahead!</p>
      </div>
    <% } %>

<!--    <div class="card">
      <h2>Welcome, <%= email %>!</h2>
      <p>Explore your creative journey, check your past drawings or start a new one now.</p>
      <button class="btn" onclick="window.location.href='index.jsp'">New Drawing</button>
      <button class="btn" onclick="window.location.href='gallery.jsp'">Gallery</button>
    </div>-->

<div class="welcome-card">
  <div class="welcome-circle">
    <div class="welcome-text">
      Welcome, <%= username != null ? username : "Artist" %>!
    </div>
  </div>
</div>


    <div class="card">
      <h2>Your Stats</h2>
      <p>Drawings Uploaded: 10</p>
      <p>Favorites Received: 35</p>
    </div>
    <div class="card">
        <h2>Update Profile</h2>
        <a href="update-profile.jsp">Click here</a>
        
    </div>
  </div>
    
    

  <footer>&copy; 2025 Zenijah. Draw your soul. 🎨</footer>
</body>
</html>
