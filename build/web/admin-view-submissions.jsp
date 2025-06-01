<%-- 
    Document   : admin-view-submissions
    Created on : May 6, 2025, 10:13:14 PM
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

    Connection conn = DBConnection.getConnection();
    PreparedStatement ps = conn.prepareStatement("SELECT s.user_email, s.submission_url, c.title, c.challenge_date FROM challenge_submissions s JOIN daily_challenges c ON s.challenge_id = c.id ORDER BY c.challenge_date DESC, s.submission_time DESC");
    ResultSet rs = ps.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Submissions</title>
    <link rel="stylesheet" href="main.css">
</head>
<body class = "dashboard">
    <header class ="dashboard-header">
        <h1>Zenijah</h1>
        <nav>
            <a href ="index.jsp">Home</a>
            <a href="logout.jsp">Logout</a>
        </nav>
    </header>
    <h1>All Daily Challenge Submissions</h1>
    <table border="1">
        <tr>
            <th>User</th>
            <th>Challenge</th>
            <th>Date</th>
            <th>Submission</th>
        </tr>
        <% while (rs.next()) { %>
        <tr>
            <td><%= rs.getString("user_email") %></td>
            <td><%= rs.getString("title") %></td>
            <td><%= rs.getDate("challenge_date") %></td>
            <td><img src="<%= rs.getString("submission_url") %>" width="100" /></td>
        </tr>
        <% } %>
    </table>
</body>
</html>
