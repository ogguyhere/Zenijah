<%-- 
    Document   : admin-upload-doodle
    Created on : May 10, 2025, 6:46:56 AM
    Author     : kay
--%>

<%@ page import="java.sql.*, com.zenijah.utils.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Boolean isAdmin = (Boolean) session.getAttribute("is_admin");
    if (isAdmin == null || !isAdmin) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Upload New Doodle</title>
    <link rel ="stylesheet" href="main.css">
</head>
<body class = "dashboard">
    <header class = "dashboard-header">
        <h1>🔐Zenijah</h1>
        <nav>
          <a href="index.jsp">Home</a>
          <a href ="admin-dashboard.jsp"> Admin-Dashboard</a>
          <a href="logout.jsp">Logout</a>
        </nav>
    </header>

    <h1 style="text-align: center">Upload New Daily Challenge</h1>
    <main class = "dashboard-container">
        <div class ="card">
            <form action="DoodleServlet" method="post" enctype="multipart/form-data">
       
  
        <input type ="text" name="title" placeholder="Title" required class ="input-field"> <br>
        <input type="file" name="challenge_image" placeholder="Upload Image" required class="input-field"> <br>
        <button type="submit" class="btn">Upload Doodle</button>
    </form>
        </div>
    </main>
    
</body>
</html>
