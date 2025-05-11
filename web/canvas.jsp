<%-- 
    Document   : canvas.jsp
    Created on : May 10, 2025
    Author     : Grok
--%>
<%@ page import="java.sql.*, com.zenijah.utils.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if user is logged in
    Integer userId = (Integer) session.getAttribute("id");

    System.out.println("user id from canvas" + userId);

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Fetch today's challenge
    String challengeImage = "";
    String challengeTitle = "";
    int challengeId = 0;
    try (Connection conn = DBConnection.getConnection()) {
        PreparedStatement ps = conn.prepareStatement(
                "SELECT id, title, image_url FROM doodles WHERE id = 3 ");
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            challengeId = rs.getInt("id");
            challengeTitle = rs.getString("title");
            challengeImage = rs.getString("image_url");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Daily Doodle Challenge</title>
    <link rel="stylesheet" href="main.css">
    <style>
        .canvas-container {
            display: flex;
            justify-content: space-around;
            margin: 20px;
        }
/*        .card {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: center;
        }*/
        canvas {
            border: 1px solid #000;
        }
        .leaderboard {
            margin: 20px;
            border: 1px solid #ccc;
            padding: 10px;
        }
        .leaderboard table {
            width: 100%;
            border-collapse: collapse;
        }
        .leaderboard th, .leaderboard td {
            border: 1px solid #ccc;
            padding: 5px;
        }
    </style>
</head>
<body class="dashboard">
    <header class="dashboard-header">
        <h1>🎨 Kids Art Studio</h1>
        <nav>
            <a href="index.jsp">Home</a>
            <a href="logout.jsp">Logout</a>
        </nav>
    </header>

    <main class="dashboard-container">
        <h1 style="text-align: center">Daily Doodle Challenge: <%= challengeTitle %></h1>
        <div class="canvas-container">
            <div class="card">
                <h2>Your Doodle</h2>
                <canvas id="drawingCanvas" width="400" height="400"></canvas>
                <br>
                <button onclick="clearCanvas()" class="btn">Clear Canvas</button>
                <button onclick="submitDoodle()" class="btn">Submit Doodle</button>
            </div>
            <div class="card">
                <h2>Reference Doodle</h2>
                <img src="<%= challengeImage %>" alt="Challenge Doodle" width="400" height="400">
            </div>
        </div>

        <div class="leaderboard">
            <h2>Leaderboard</h2>
            <table>
                <tr>
                    <th>User ID</th>
                    <th>Rating</th>
                    <th>Doodle</th>
                    <th>Submission Date</th>
                </tr>
                <%
                    try (Connection conn = DBConnection.getConnection()) {
                        PreparedStatement ps = conn.prepareStatement(
                                "SELECT user_id, doodle_url, rating, submission_date FROM doodle_submissions WHERE challenge_id = ? ORDER BY rating DESC");
                        ps.setInt(1, challengeId);
                        ResultSet rs = ps.executeQuery();
                        while (rs.next()) {
                            %>
                            <tr>
                                <td><%= rs.getInt("user_id") %></td>
                                <td><%= rs.getInt("rating") %></td>
                                <td><img src="<%= rs.getString("doodle_url") %>" alt="Doodle" width="50" height="50"></td>
                                <td><%= rs.getTimestamp("submission_date") %></td>
                            </tr>
                            <%
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                %>
            </table>
        </div>
    </main>

    <footer>
        <p>&copy; 2025 Kids Art Studio</p>
    </footer>

    <script>
        const canvas = document.getElementById('drawingCanvas');
        const ctx = canvas.getContext('2d');
        let isDrawing = false;

        canvas.addEventListener('mousedown', () => isDrawing = true);
        canvas.addEventListener('mouseup', () => isDrawing = false);
        canvas.addEventListener('mousemove', draw);

        function draw(event) {
            if (!isDrawing) return;
            ctx.lineWidth = 5;
            ctx.lineCap = 'round';
            ctx.strokeStyle = 'black';

            ctx.lineTo(event.offsetX, event.offsetY);
            ctx.stroke();
            ctx.beginPath();
            ctx.moveTo(event.offsetX, event.offsetY);
        }

        function clearCanvas() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
        }

        function submitDoodle() {
            const dataURL = canvas.toDataURL('image/png');
            const formData = new FormData();
            formData.append('doodle', dataURL);
            formData.append('challenge_id', <%= challengeId %>);
            formData.append('user_id', <%= userId %>);

            fetch('Process_DoodleServlet', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                alert('Doodle submitted! Rating: ' + data.rating + '/10');
                window.location.reload(); // Refresh to update leaderboard
            })
            .catch(error => console.error('Error:', error));
        }
    </script>
</body>
</html>