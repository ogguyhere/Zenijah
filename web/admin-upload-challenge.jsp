<%-- 
    Document   : admin-upload-challenge.jsp
    Created on : May 7, 2025, 2:17:31 AM
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
    <title>Upload New Challenge</title>
    <link rel ="stylesheet" href="main.css">
</head>
<body class = "dashboard">
    <header class = "dashboard-header">
        <h1>🔐 Zenijah Login</h1>
        <nav>
          <a href="index.jsp">Home</a>
          <a href="logout.jsp">Logout</a>
        </nav>
    </header>

    <h1 style="text-align: center">Upload New Daily Challenge</h1>
    <main class = "dashboard-container">
        <div class ="card">
            <form action="process-challenge-upload" method="post" enctype="multipart/form-data">
       
  
        <input type ="text" name="title" placeholder="Title" required class ="input-field"> <br>
        <input type="date" name="date" placeholder="Challenge Date" required class="input-field"> <br>
        <input type="file" name="challenge_image" placeholder="Upload Image" required class="input-field"> <br>
        <button type="submit" class="btn">Upload Challenge</button>
    </form>
        </div>
    </main>
    
</body>
</html>
