<%-- 
    Document   : logout
    Created on : May 5, 2025, 5:47:41 PM
    Author     : kay
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  // Invalidate the session to log the user out
  if (session != null) {
      session.invalidate();
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Logged Out</title>
  <link rel="stylesheet" href="main.css" />
</head>
<body class="dashboard">
  <header class="dashboard-header">
    <h1>👋 Logged Out</h1>
  </header>
  <div class="dashboard-container">
    <div class="card">
      <h2>You have successfully logged out!</h2>
      <p>Come back soon, artist 🖋️</p>
      <a href="login.jsp" class="btn">Login Again</a>
    </div>
  </div>
</body>
</html>
