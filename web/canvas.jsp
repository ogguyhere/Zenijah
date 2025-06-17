<%@ page import="java.sql.*, com.zenijah.utils.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer userId = (Integer) session.getAttribute("id");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String challengeImage = "";
    String challengeTitle = "";
    int challengeId = 0;

    try (Connection conn = DBConnection.getConnection()) {
        PreparedStatement ps = conn.prepareStatement(
            "SELECT id, title, image_url FROM doodles WHERE id = 5"
        );
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
        body.vibrant-theme {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #f5f7fa, #c3cfe2);
            color: #333;
        }

        .vibrant-header {
            background-color: #4f46e5;
            color: white;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .vibrant-header h1 {
            margin: 0;
            font-size: 1.8rem;
        }

        .vibrant-header nav a {
            color: white;
            margin-left: 1rem;
            text-decoration: none;
            font-weight: bold;
        }

        .vibrant-main {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 1rem;
        }

        .canvas-wrapper {
            display: flex;
            flex-wrap: wrap;
            gap: 2rem;
            justify-content: center;
            margin-bottom: 3rem;
        }

        .doodle-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.1);
            padding: 1rem;
            flex: 1 1 45%;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .doodle-card h2 {
            color: #4f46e5;
            margin-bottom: 1rem;
        }

        canvas {
            border: 2px dashed #4f46e5;
            width: 100%;
            max-width: 500px;
            height: 500px;
            background-color: #ffffff;
        }

        .doodle-card img {
            max-width: 100%;
            border: 2px dashed #4f46e5;
            border-radius: 8px;
            height: 500px;
            object-fit: contain;
        }

        .btn-group {
            margin-top: 1rem;
        }

        .btn-vibrant {
            background-color: #4f46e5;
            color: white;
            border: none;
            padding: 0.6rem 1.2rem;
            margin: 0.3rem;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s;
        }

        .btn-vibrant:hover {
            background-color: #4338ca;
        }

        .leaderboard-section {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.1);
            padding: 2rem;
        }

        .leaderboard-section h2 {
            color: #4f46e5;
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        th, td {
            padding: 0.75rem;
            text-align: center;
            border: 1px solid #ddd;
        }

        th {
            background-color: #4f46e5;
            color: white;
        }
        button {
    background: linear-gradient(to right,#ff90c2, #ffd1dc);
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 8px;
    cursor: pointer;
    font-weight: bold;
    transition: background 0.3s ease;
}

button:hover {
    background: linear-gradient(to right, #2575fc, #6a11cb);
}

        .toolbar {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            justify-content: center;
            margin-bottom: 1rem;
        }

        footer.vibrant-footer {
            margin-top: 3rem;
            text-align: center;
            padding: 1rem;
            background-color: #4f46e5;
            color: white;
        }
    </style>
</head>
<body class ="dashboard">
    <header class ="dashboard-header">
        <h1>🎨 Zenijah</h1>
        <nav>
            <a href="index.jsp">Home</a>
            <a href="logout.jsp">Logout</a>
        </nav>
    </header>
</body>
<body class="vibrant-theme">
<!--    <header class="vibrant-header">
        <h1>🎨 Zenijah</h1>
        <nav>
            <a href="index.jsp">Home</a>
            <a href="logout.jsp">Logout</a>
        </nav>
    </header>-->
<main class="vibrant-main">
    <h1 style="text-align: center">Daily Doodle Challenge: <%= challengeTitle %></h1>
    <br><br>
    <div class="canvas-wrapper">
        <!-- Left: Your Doodle Canvas -->
        <div class="doodle-card">
            <h2>Your Doodle</h2>
            <div class="toolbar">
                <label>Tool:
                    <select id="tool">
                        <option value="brush">Brush</option>
                        <option value="eraser">Eraser</option>
                        <option value="line">Line</option>
                        <option value="rectangle">Rectangle</option>
                        <option value="circle">Circle</option>
                        <option value="text">Text</option>
                    </select>
                </label>

                <label>Color: <input type="color" id="color" value="#000000"></label>
                <label>Size: <input type="range" id="size" min="1" max="30" value="5"></label>
                <button onclick="undo()">Undo</button>
                <button onclick="clearCanvas()">Clear</button>
                <button onclick="downloadCanvas()">Download</button>
                <button onclick="submitDoodle()">Submit</button>
            </div>

            <canvas id="drawingCanvas" width="600" height="500"></canvas>
        </div>

        <!-- Right: Reference Image -->
        <div class="doodle-card">
            <h2>Reference</h2>
            <img src="<%= challengeImage %>" alt="Challenge Doodle">
        </div>
    </div>

    <!-- Leaderboard Below -->
<!--    <div class="leaderboard-section">
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
                        "SELECT user_id, doodle_url, rating, submission_date FROM doodle_submissions WHERE challenge_id = ? ORDER BY rating DESC"
                    );
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
</main>-->

<!--    <main class="vibrant-main">
        <h1 style="text-align: center">Daily Doodle Challenge: <%= challengeTitle %></h1>
<div class="canvas-wrapper">
    <h2>Your Doodle</h2>
    <div class="toolbar">
        <label>Tool:
            <select id="tool">
                <option value="brush">Brush</option>
                <option value="eraser">Eraser</option>
                <option value="line">Line</option>
                <option value="rectangle">Rectangle</option>
                <option value="circle">Circle</option>
                <option value="text">Text</option>
            </select>
        </label>

        <label>Color: <input type="color" id="color" value="#000000"></label>
        <label>Size: <input type="range" id="size" min="1" max="30" value="5"></label>
        <button onclick="undo()">Undo</button>
        <button onclick="clearCanvas()">Clear</button>
        <button onclick="downloadCanvas()">Download</button>
        <button onclick="submitDoodle()">Submit</button>
    </div>

    <canvas id="drawingCanvas" width="600" height="500"></canvas>
</div>

        <div class="canvas-wrapper">
            <div class="doodle-card">
                <h2>Your Doodle</h2>
                <canvas id="drawingCanvas" width="500" height="500"></canvas>
                <div class="btn-group">
                    <button onclick="clearCanvas()" class="btn-vibrant">Clear</button>
                    <button onclick="submitDoodle()" class="btn-vibrant">Submit</button>
                </div>
            </div>

            <div class="doodle-card">
                <h2>Reference</h2>
                <img src="<%= challengeImage %>" alt="Challenge Doodle">
            </div>
        </div>-->

<!--        <div class="leaderboard-section">
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
                            "SELECT user_id, doodle_url, rating, submission_date FROM doodle_submissions WHERE challenge_id = ? ORDER BY rating DESC"
                        );
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
        </div>-->
    </main>-->

<!--    <footer class="vibrant-footer">
        <p>&copy; 2025 Zenijah</p>
    </footer>-->
<script>
const canvas = document.getElementById('drawingCanvas');
const ctx = canvas.getContext('2d');
let isDrawing = false;
let paths = [];  // For undo
let tool = 'brush';
let color = document.getElementById('color').value;
let size = document.getElementById('size').value;
let startX, startY;
let imageData;

document.getElementById('tool').addEventListener('change', e => tool = e.target.value);
document.getElementById('color').addEventListener('input', e => color = e.target.value);
document.getElementById('size').addEventListener('input', e => size = e.target.value);

canvas.addEventListener('mousedown', e => {
    isDrawing = true;
    ctx.beginPath();
    ctx.lineWidth = size;
    ctx.strokeStyle = tool === 'eraser' ? '#ffffff' : color;
    ctx.fillStyle = color;
    ctx.lineCap = 'round';

    startX = e.offsetX;
    startY = e.offsetY;
    imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
});

canvas.addEventListener('mousemove', e => {
    if (!isDrawing) return;

    if (tool === 'brush' || tool === 'eraser') {
        ctx.lineTo(e.offsetX, e.offsetY);
        ctx.stroke();
    }
});

canvas.addEventListener('mouseup', e => {
    isDrawing = false;

    if (tool === 'line') {
        ctx.putImageData(imageData, 0, 0);
        ctx.beginPath();
        ctx.moveTo(startX, startY);
        ctx.lineTo(e.offsetX, e.offsetY);
        ctx.stroke();
    } else if (tool === 'rectangle') {
        ctx.putImageData(imageData, 0, 0);
        ctx.strokeRect(startX, startY, e.offsetX - startX, e.offsetY - startY);
    } else if (tool === 'circle') {
        ctx.putImageData(imageData, 0, 0);
        ctx.beginPath();
        const radius = Math.sqrt(Math.pow(e.offsetX - startX, 2) + Math.pow(e.offsetY - startY, 2));
        ctx.arc(startX, startY, radius, 0, 2 * Math.PI);
        ctx.stroke();
    } else if (tool === 'text') {
        const text = prompt("Enter text:");
        if (text) ctx.fillText(text, startX, startY);
    }

    ctx.beginPath();
    paths.push(ctx.getImageData(0, 0, canvas.width, canvas.height));
});

function clearCanvas() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    paths = [];
}

function undo() {
    if (paths.length > 0) {
        paths.pop();
        if (paths.length > 0) {
            ctx.putImageData(paths[paths.length - 1], 0, 0);
        } else {
            clearCanvas();
        }
    }
}

function downloadCanvas() {
    const a = document.createElement('a');
    a.download = 'my-doodle.png';
    a.href = canvas.toDataURL();
    a.click();
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
        window.location.reload();
    })
    .catch(error => console.error('Error:', error));
}
</script>

</body>

<body class="dashboard"><!-- comment -->
   
  <footer>
    <p>© 2025 Zenijah. Where Art Meets Fun 🎨 | Crafted with 💕 by Kay</p>
  </footer>
</body>
</html>
