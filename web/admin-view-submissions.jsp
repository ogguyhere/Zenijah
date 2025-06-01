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
    <style>
        /* Extra page-specific tweaks */
        .submission-container {
            max-width: 1100px;
            margin: 2rem auto;
            background: #fffdfd;
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 8px 16px rgba(255, 153, 204, 0.2);
        }

        .submission-container h2 {
            text-align: center;
            color: #cc0077;
            margin-bottom: 1.5rem;
            font-family: 'Fredoka', sans-serif;
        }

        table.submissions {
            width: 100%;
            border-collapse: collapse;
            font-family: 'Fredoka', sans-serif;
        }

        table.submissions th,
        table.submissions td {
            border: 2px dashed #ffaadd;
            padding: 12px 15px;
            text-align: center;
            color: #660066;
        }

        table.submissions th {
            background: #fff0f9;
            font-size: 1.1rem;
        }

        table.submissions td img {
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(255, 182, 193, 0.3);
        }

        table.submissions tr:nth-child(even) {
            background-color: #fff7fc;
        }

        table.submissions tr:hover {
            background-color: #ffe6f0;
            transition: 0.3s;
        }
    </style>
</head>
<body class="dashboard">
    <header class="dashboard-header">
        <h1>Zenijah</h1>
        <nav>
            <a href="index.jsp">Home</a>
            <a href="logout.jsp">Logout</a>
        </nav>
    </header>

    <div class="submission-container">
        <h2>🌸 All Daily Challenge Submissions 🌸</h2>
        <table class="submissions">
            <thead>
                <tr>
                    <th>User</th>
                    <th>Challenge</th>
                    <th>Date</th>
                    <th>Submission</th>
                </tr>
            </thead>
            <tbody>
            <% while (rs.next()) { %>
                <tr>
                    <td><%= rs.getString("user_email") %></td>
                    <td><%= rs.getString("title") %></td>
                    <td><%= rs.getDate("challenge_date") %></td>
                    <td><img src="<%= rs.getString("submission_url") %>" width="100" /></td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>
