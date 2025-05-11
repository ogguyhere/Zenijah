<%-- 
    Document   : daily-challenge
    Created on : May 6, 2025, 10:10:07 PM
    Author     : kay
--%>

<%@ page import="java.sql.*, java.time.*, com.zenijah.utils.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String email = (String) session.getAttribute("email");
    if (email == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = DBConnection.getConnection();
    LocalDate today = LocalDate.now();

    String challengeImageUrl = null;
    int challengeId = -1;
    String userSubmissionUrl = null;

    // Fetch today's challenge
    PreparedStatement ps = conn.prepareStatement("SELECT * FROM daily_challenges WHERE challenge_date = ?");
    ps.setDate(1, java.sql.Date.valueOf(today));
    ResultSet rs = ps.executeQuery();
    if (rs.next()) {
        challengeId = rs.getInt("id");
        challengeImageUrl = rs.getString("image_url");
    }

    // Fetch user submission
    if (challengeId != -1) {
        ps = conn.prepareStatement("SELECT submission_url FROM challenge_submissions WHERE challenge_id = ? AND user_email = ?");
        ps.setInt(1, challengeId);
        ps.setString(2, email);
        rs = ps.executeQuery();
        if (rs.next()) { 
            userSubmissionUrl = rs.getString("submission_url");
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Daily Challenge</title>
    <link rel="stylesheet" href="main.css">
</head>
<body class="dashboard kids-theme">
    <header class="dashboard-header">
        <h1>Zenijah Daily Challenge</h1>
        <nav>
            <a href="index.jsp">Home</a>
            <a href="logout.jsp">Logout</a>
        </nav>
    </header>

    <div class="dashboard-container">
        <div class="card welcome-card">
            <h2>Today's Drawing Challenge</h2>
            <% if (challengeImageUrl != null) { %>
                <img src="<%= challengeImageUrl %>" width="300" />
            <% } else { %>
                <p>No challenge posted for today.</p>
            <% } %>
        </div>

        <div class="card">
            <h2>Your Submission</h2>
            <% if (userSubmissionUrl != null) { %>
                <img src="<%= userSubmissionUrl %>" width="300" />
            <% } else if (challengeId != -1) { %>
                <form action="uploadSubmission.jsp" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="challengeId" value="<%= challengeId %>" />
                    <input class="input-field" type="file" name="submission" required />
                    <button class="btn" type="submit">Upload</button>
                </form>
            <% } else { %>
                <p>No challenge to submit yet!</p>
            <% } %>
        </div>
    </div>

    <footer>
        &copy; 2025 Zenijah Kids Club. Keep drawing, keep shining! 🌟
    </footer>
</body>
</html>
