<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Zenijah - Home</title>
  <link rel="stylesheet" href="main.css" />
<!--  <style>
    body {
      font-family: 'Quicksand', sans-serif;
      background: linear-gradient(145deg, #0f0f0f, #1a1a1a);
      color: #fbeaff;
      margin: 0;
      padding: 0;
    }
    .dashboard-header {
      background: #1e1e1eaa;
      backdrop-filter: blur(6px);
      padding: 20px;
      text-align: center;
      border-bottom: 2px solid #333;
    }
    nav a, nav span {
      margin: 0 10px;
      text-decoration: none;
      color: #ff92df;
      font-weight: bold;
      transition: color 0.3s ease;
    }
    nav a:hover {
      color: #e46ecb;
    }
    .dashboard-container {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 2rem;
      padding: 3rem 1rem;
    }
    .card {
      background: #2b2b2b;
      border-radius: 15px;
      padding: 2rem;
      box-shadow: 0 8px 20px rgba(255, 182, 249, 0.08);
      width: 90%;
      max-width: 900px;
      text-align: center;
    }
    .btn {
      background: linear-gradient(135deg, #fcd34d, #facc15);
      color: #292524;
      box-shadow: 0 0 10px #fde68a;
      border: none;
      padding: 10px 20px;
      font-weight: bold;
      border-radius: 10px;
      cursor: pointer;
      transition: all 0.2s ease-in-out;
    }
    .btn:hover {
      background: linear-gradient(135deg, #fbbf24, #f59e0b);
      transform: scale(1.08);
    }
    canvas {
      margin-top: 1rem;
      background: #fff8fc;
      border: 4px dashed #ffccff;
      border-radius: 20px;
    }
    footer {
      text-align: center;
      padding: 1rem;
      background: #1e1e1e;
      border-top: 1px solid #333;
      margin-top: 3rem;
      font-size: 0.9rem;
      color: #aaa;
    }
    ul {
      list-style-type: "🌙 ";
      text-align: left;
    }
    .doodle-container {
      position: absolute;
      width: 100%;
      height: 100%;
      pointer-events: none;
      z-index: 0;
    }
    .doodle {
      position: absolute;
      font-size: 24px;
      animation: float 6s infinite ease-in-out;
    }
    @keyframes float {
      0% { transform: translateY(0px); }
      50% { transform: translateY(-20px); }
      100% { transform: translateY(0px); }
    }
  </style>-->
</head>

<body class="dashboard">
    <canvas id="particle-canvas"></canvas>

  <header class="dashboard-header">
    <h1>🏠 Welcome to Zenijah</h1>
    <nav>
      <%
        Boolean isAdmin = (Boolean) session.getAttribute("is_admin");
        String email = (String) session.getAttribute("email");
        if (email == null) {
      %>
        <a href="login.jsp">Login</a>
        <a href="register.jsp">Register</a>
        <a href="canvas.jsp">Drawing Zone</a>
        <a href="gallery.jsp">Gallery</a>
      <% } else { %>
        <span>Welcome, <%= email %>!</span>
        <% if (isAdmin != null && isAdmin) { %>
          <a href="admin-dashboard.jsp">Admin Dashboard</a>
        <% } else { %>
          <a href="user-dashboard.jsp">Dashboard</a>
        <% } %>
        <a href="logout.jsp">Logout</a>
        <a href="canvas.jsp">Kids Zone</a>
        <a href="gallery.jsp">Gallery</a>
      <% } %>
    </nav>
  </header>
<div class="side-decoration left">
  <div class="floating-cloud"></div>
  <div class="cute-robot"></div>
</div>

<div class="side-decoration right">
  <div class="floating-star"></div>
  <div class="art-palette"></div>
</div>

<!-- Modify your main content container -->
<main class="dashboard-container">
  <div class="welcome-section">
    <!--<div class="welcome-mascot">-->
      <!--<div class="mascot-body"></div>-->
      <div class="mascot-paintbrush"></div>
    </div>
  <!-- Floating Doodles -->
  <div class="doodle-container"></div>



  <main class="dashboard-container">
      <div class="intro-banner">
  <h2>🖌️ Explore Your Creativity with Zenijah!</h2>
  <p>Draw, Save, and Share your magical creations with the world.</p>
</div>

    <div class="card welcome-card">
      <h2 style="font-family: 'Comic Neue'; font-size: 2.5rem;">🌈 Hello Little Artists!</h2>
      <p style="font-size: 1.2rem;">Zenijah is your magical space to draw, dream, and decorate. ✏️🧚‍♀️<br>Let's make something beautiful together!</p>
    </div>
      <br><br><br>
      <div class="card">
  <h2>💡 Try This!</h2>
  <p id="tip-box">Try using the 🧽 eraser to make stars!</p>
</div>

<script>
  const tips = [
    "Try using the 🧽 eraser to make stars!",
    "Use 🌈 mode and draw a rainbow!",
    "Draw your favorite cartoon character!",
    "Make a family portrait with fun colors!",
  ];
  let tipIndex = 0;
  setInterval(() => {
    tipIndex = (tipIndex + 1) % tips.length;
    document.getElementById('tip-box').innerText = tips[tipIndex];
  }, 5000);
</script>

<br><br><br>
    <div class="card">
      <h2>🎨 Draw Your Art</h2>
      <canvas id="canvas" width="800" height="500"></canvas>
      <div class="controls" style="margin-top: 1.5rem; display: flex; justify-content: center; gap: 1rem; flex-wrap: wrap;">
        <input type="color" id="colorPicker" />
        <input type="range" id="brushSize" min="1" max="20" value="5" />
        <button class="btn" onclick="clearCanvas()">🧼 Clear</button>
        <button class="btn" onclick="saveDrawing()">💾 Save</button>
        <button class="btn" onclick="toggleRainbow()" id="rainbowBtn">🌈 Rainbow</button>
    <button class="btn" onclick="enableEraser()">🧽 Eraser</button>
    <button class="btn" onclick="undo()">⏪ Undo</button>
    <button class="btn" onclick="redo()">⏩ Redo</button>
      </div>
    </div>
<br><br><br>
    <div class="card">
      <h2>🖼️ My Saved Gallery</h2>
      <p>See your previous masterpieces!</p>
      <a href="gallery.jsp" class="btn">Go to Gallery</a>
    </div>

<br><br><br>
      <div class="card">
  <h2>🧠 Did You Know?</h2>
  <ul>
    <li>Drawing can improve your memory and reduce stress!</li>
    <li>Kids who draw regularly boost their creative thinking.</li>
    <li>Every famous artist started as a beginner—just like you!</li>
  </ul>
</div>
<br><br><br>
<div class="card">
  <h2>💬 What Our Little Artists Say</h2>
  <div id="testimonial-box">
    <p id="testimonial">"Zenijah makes me feel like a real artist!" – Aanya, Age 7</p>
  </div>
</div>
<br><br><br>
<script>
  const testimonials = [
    `"Zenijah makes me feel like a real artist!" – Aanya, Age 7`,
    `"I drew my cat and showed my school friends!" – Kabir, Age 8`,
    `"My mom loves my saved drawings!" – Reema, Age 6`,
  ];
  let tIndex = 0;
  setInterval(() => {
    tIndex = (tIndex + 1) % testimonials.length;
    document.getElementById('testimonial').innerText = testimonials[tIndex];
  }, 4000);
</script>

    <div class="card">
      <h2>✨ Why You'll Love Zenijah</h2>
      <ul>
        <li>Fun & easy drawing tools</li>
        <li>Upload & view your art in the gallery</li>
        <li>Safe space for kids to play</li>
        <li>Admin & user dashboards</li>
        <li>Cute themes and animations</li>
      </ul>
    </div>

  <script>
  const pc = document.getElementById('particle-canvas');
  const pctx = pc.getContext('2d');
  pc.width = window.innerWidth;
  pc.height = window.innerHeight;
  let particles = Array.from({ length: 60 }, () => ({
    x: Math.random() * pc.width,
    y: Math.random() * pc.height,
    r: Math.random() * 3 + 1,
    dx: Math.random() - 0.5,
    dy: Math.random() - 0.5
  }));

  function animateParticles() {
    pctx.clearRect(0, 0, pc.width, pc.height);
    particles.forEach(p => {
      pctx.beginPath();
      pctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
      pctx.fillStyle = "#ffccff";
      pctx.fill();
      p.x += p.dx;
      p.y += p.dy;
      if (p.x < 0 || p.x > pc.width) p.dx *= -1;
      if (p.y < 0 || p.y > pc.height) p.dy *= -1;
    });
    requestAnimationFrame(animateParticles);
  }
  animateParticles();
</script>


  <!-- Scripts -->
  <script>
    // Canvas setup
    const canvas = document.getElementById('canvas');
    const ctx = canvas.getContext('2d');
    let painting = false;
    let brushColor = document.getElementById('colorPicker').value;
    let brushSize = document.getElementById('brushSize').value;
    let lastX = 0, lastY = 0;

    canvas.addEventListener('mousedown', (e) => {
      painting = true;
      [lastX, lastY] = [e.offsetX, e.offsetY];
      saveState();
    });
    canvas.addEventListener('mouseup', () => painting = false);
    canvas.addEventListener('mouseout', () => painting = false);
    canvas.addEventListener('mousemove', draw);

    document.getElementById('colorPicker').addEventListener('change', e => brushColor = e.target.value);
    document.getElementById('brushSize').addEventListener('change', e => brushSize = e.target.value);

    function draw(e) {
      if (!painting) return;
      ctx.beginPath();
      ctx.moveTo(lastX, lastY);
      ctx.lineTo(e.offsetX, e.offsetY);
      ctx.strokeStyle = rainbowMode ? getRainbowColor() : brushColor;
      ctx.lineWidth = brushSize;
      ctx.lineCap = 'round';
      ctx.stroke();
      [lastX, lastY] = [e.offsetX, e.offsetY];
    }

    // Rainbow mode
    let rainbowMode = false;
    function toggleRainbow() {
      rainbowMode = !rainbowMode;
      document.getElementById('rainbowBtn').classList.toggle('active');
    }

    let hue = 0;
    function getRainbowColor() {
      hue = (hue + 1) % 360;
      return `hsl(${hue}, 100%, 50%)`;
    }

    function clearCanvas() {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      saveState();
    }

    function saveDrawing() {
      const dataURL = canvas.toDataURL('image/png');
      const link = document.createElement('a');
      link.download = 'my-drawing.png';
      link.href = dataURL;
      link.click();
    }

    // Eraser
    function enableEraser() {
      brushColor = '#fff8fc';
    }

    // Undo/Redo
    const drawingHistory = [];
    let currentStep = -1;

    function saveState() {
      currentStep++;
      if (currentStep < drawingHistory.length) {
        drawingHistory.length = currentStep;
      }
      drawingHistory.push(canvas.toDataURL());
    }

    function undo() {
      if (currentStep <= 0) return;
      currentStep--;
      restoreState();
    }

    function redo() {
      if (currentStep >= drawingHistory.length - 1) return;
      currentStep++;
      restoreState();
    }

    function restoreState() {
      const img = new Image();
      img.src = drawingHistory[currentStep];
      img.onload = () => ctx.drawImage(img, 0, 0);
    }

    // Doodles
    const doodles = ['🎨', '🖌️', '🌟', '🐰', '🌈', '🦄', '🎈', '🍭'];
    const doodleContainer = document.querySelector('.doodle-container');

    for (let i = 0; i < 15; i++) {
      const doodle = document.createElement('div');
      doodle.className = 'doodle';
      doodle.textContent = doodles[Math.floor(Math.random() * doodles.length)];
      doodle.style.left = Math.random() * 100 + '%';
      doodle.style.top = Math.random() * 100 + '%';
      doodle.style.fontSize = Math.random() * 30 + 20 + 'px';
      doodleContainer.appendChild(doodle);
    }
  </script>
  </main>
<footer>
    <p>&copy; 2025 Zenijah. Where Art Meets Fun 🎨 | Crafted with 💕 by Kay</p>
  </footer>
  
</body>
</html>
