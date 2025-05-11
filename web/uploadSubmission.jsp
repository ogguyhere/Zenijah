<%-- 
    Document   : uploadSubmission
    Created on : May 6, 2025, 10:11:32 PM
    Author     : kay
--%>
<%@ page import="java.io.*, java.nio.file.*, java.sql.*, com.zenijah.utils.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Upload Submission - Zenijah</title>
    <link rel="stylesheet" href="zenijah-dashboard.css"> <%-- link to your CSS --%>
</head>
<body class="dashboard kids-theme">

<%
    String email = (String) session.getAttribute("email");
    if (email == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String challengeIdParam = request.getParameter("challengeId");
    if (challengeIdParam == null || challengeIdParam.isEmpty()) {
%>
        <div class="dashboard-container">
            <div class="card welcome-card">
                <h2>Oops! 🚫</h2>
                <p>Challenge ID is missing. Please try again from the challenge page.</p>
                <a href="daily-challenge.jsp" class="btn">Go Back</a>
            </div>
        </div>
<%
        return;
    }

    int challengeId = Integer.parseInt(challengeIdParam);
    Part filePart = request.getPart("submission");

    if (filePart == null) {
%>
        <div class="dashboard-container">
            <div class="card welcome-card">
                <h2>Error 📁</h2>
                <p>No file was uploaded. Please select a file and try again.</p>
                <a href="daily-challenge.jsp" class="btn">Go Back</a>
            </div>
        </div>
<%
        return;
    }

    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
    String uploadDir = application.getRealPath("/") + "uploads/";
    new File(uploadDir).mkdirs();

    String fullPath = uploadDir + fileName;
    filePart.write(fullPath);

    String submissionUrl = "uploads/" + fileName;

    try (Connection conn = DBConnection.getConnection()) {
        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO challenge_submissions (user_email, challenge_id, submission_url) VALUES (?, ?, ?)"
        );
        ps.setString(1, email);
        ps.setInt(2, challengeId);
        ps.setString(3, submissionUrl);
        ps.executeUpdate();
%>
        <div class="dashboard-container">
            <div class="card welcome-card">
                <h2>✨ Submission Successful!</h2>
                <p>You've successfully uploaded your solution. Great job!</p>
                <a href="daily-challenge.jsp" class="btn">Back to Challenges</a>
            </div>
        </div>
<%
    } catch (SQLException e) {
        e.printStackTrace();
%>
        <div class="dashboard-container">
            <div class="card welcome-card">
                <h2>Database Error 😓</h2>
                <p>Something went wrong while saving your submission. Please try again later.</p>
                <a href="daily-challenge.jsp" class="btn">Try Again</a>
            </div>
        </div>
<%
    }
%>

<footer>
    &copy; 2025 Zenijah. Crafted with creativity 🌈.
</footer>
</body>
</html>
