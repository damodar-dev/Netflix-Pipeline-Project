<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Netflix - Damodar</title>
    <style>
      * { margin: 0; padding: 0; box-sizing: border-box; }

      body {
        font-family: Arial, sans-serif;
        background: #141414;
        color: white;
        display: flex;
        height: 100vh;
        overflow: hidden;
      }

      /* ══════════════════════════════════
         LEFT SIDE — HOME
      ══════════════════════════════════ */
      .left-panel {
        flex: 1;
        overflow-y: auto;
        scrollbar-width: thin;
        scrollbar-color: #555 #141414;
      }

      .left-panel::-webkit-scrollbar { width: 5px; }
      .left-panel::-webkit-scrollbar-track { background: #141414; }
      .left-panel::-webkit-scrollbar-thumb { background: #555; border-radius: 3px; }

      /* Navbar */
      .navbar {
        position: sticky;
        top: 0;
        z-index: 20;
        padding: 14px 28px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: linear-gradient(to bottom, rgba(0,0,0,0.95), rgba(0,0,0,0.6));
      }

      .navbar img.logo { height: 28px; }

      .nav-right {
        display: flex;
        align-items: center;
        gap: 20px;
      }

      .nav-right a {
        color: #e5e5e5;
        text-decoration: none;
        font-size: 13px;
        font-weight: 500;
      }

      .nav-right a:hover { color: #b3b3b3; }

      .nav-profile {
        display: flex;
        align-items: center;
        gap: 7px;
        cursor: pointer;
      }

      .nav-profile img {
        width: 30px;
        height: 30px;
        border-radius: 4px;
        object-fit: cover;
        object-position: center; /* FIXED: full picture */
      }

      .nav-profile span {
        font-size: 13px;
        color: #e5e5e5;
        font-weight: 500;
      }

      /* Hero */
      .hero {
        position: relative;
        height: 400px;
        overflow: hidden;
      }

      .hero-bg {
        width: 100%;
        height: 100%;
        object-fit: cover;
        object-position: center;
        display: block;
      }

      .hero-overlay {
        position: absolute;
        inset: 0;
        background:
          linear-gradient(to right, rgba(0,0,0,0.85) 40%, transparent 80%),
          linear-gradient(to top, #141414 0%, transparent 40%);
      }

      .hero-content {
        position: absolute;
        bottom: 55px;
        left: 28px;
        max-width: 300px;
      }

      .hero-badge {
        background: #e50914;
        color: white;
        font-size: 10px;
        font-weight: 700;
        padding: 3px 8px;
        border-radius: 2px;
        display: inline-block;
        margin-bottom: 10px;
        letter-spacing: 1.5px;
      }

      .hero-content h1 {
        font-size: 36px;
        font-weight: 800;
        line-height: 1.05;
        color: white;
        margin-bottom: 10px;
      }

      .hero-content p {
        font-size: 12px;
        color: #ddd;
        line-height: 1.6;
        margin-bottom: 16px;
      }

      .hero-buttons { display: flex; gap: 10px; }

      .btn-play {
        background: white;
        color: black;
        border: none;
        padding: 9px 18px;
        border-radius: 4px;
        font-size: 13px;
        font-weight: 700;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 6px;
        transition: background 0.2s;
      }

      .btn-play:hover { background: rgba(255,255,255,0.85); }

      .btn-info {
        background: rgba(109,109,110,0.7);
        color: white;
        border: none;
        padding: 9px 18px;
        border-radius: 4px;
        font-size: 13px;
        font-weight: 700;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 6px;
        transition: background 0.2s;
      }

      .btn-info:hover { background: rgba(109,109,110,0.5); }

      /* Rows */
      .rows-section {
        padding: 0 28px 40px;
        margin-top: -38px;
        position: relative;
        z-index: 5;
      }

      .row { margin-bottom: 26px; }

      .row-title {
        font-size: 15px;
        font-weight: 700;
        color: #e5e5e5;
        margin-bottom: 12px;
      }

      .row-cards {
        display: flex;
        gap: 7px;
        overflow-x: auto;
        padding-bottom: 6px;
        scrollbar-width: thin;
        scrollbar-color: #555 #222;
      }

      .row-cards::-webkit-scrollbar { height: 4px; }
      .row-cards::-webkit-scrollbar-track { background: #222; }
      .row-cards::-webkit-scrollbar-thumb { background: #555; border-radius: 3px; }

      /* Continue Watching Cards */
      .cw-card { flex-shrink: 0; width: 170px; cursor: pointer; }

      .cw-thumb {
        position: relative;
        width: 170px;
        height: 96px;
        border-radius: 4px;
        overflow: hidden;
      }

      .cw-thumb img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        object-position: center; /* FIXED: show full picture */
        display: block;
        transition: transform 0.3s;
      }

      .cw-card:hover .cw-thumb img { transform: scale(1.07); }

      .progress-bar {
        position: absolute;
        bottom: 0; left: 0; right: 0;
        height: 3px;
        background: #555;
      }

      .progress-fill { height: 100%; background: #e50914; }

      .play-overlay {
        position: absolute;
        inset: 0;
        background: rgba(0,0,0,0.4);
        display: flex;
        align-items: center;
        justify-content: center;
        opacity: 0;
        transition: opacity 0.2s;
      }

      .cw-card:hover .play-overlay { opacity: 1; }

      .play-circle {
        width: 34px;
        height: 34px;
        border-radius: 50%;
        background: rgba(255,255,255,0.92);
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 13px;
        color: black;
        padding-left: 3px;
      }

      .cw-label {
        font-size: 11px;
        color: #ccc;
        margin-top: 5px;
        padding: 0 2px;
      }

      /* Color Cards */
      .color-card { flex-shrink: 0; width: 170px; cursor: pointer; }

      .color-thumb {
        width: 170px;
        height: 96px;
        border-radius: 4px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 13px;
        font-weight: 700;
        color: white;
        text-align: center;
        padding: 8px;
        transition: transform 0.3s, filter 0.3s;
      }

      .color-card:hover .color-thumb {
        transform: scale(1.07);
        filter: brightness(1.2);
      }

      .color-label {
        font-size: 11px;
        color: #ccc;
        margin-top: 5px;
        padding: 0 2px;
      }

      /* Top Picks */
      .pick-card {
        flex-shrink: 0;
        width: 130px;
        height: 74px;
        border-radius: 4px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 11px;
        font-weight: 600;
        color: #ccc;
        text-align: center;
        padding: 8px;
        cursor: pointer;
        transition: transform 0.3s, color 0.2s;
      }

      .pick-card:hover { transform: scale(1.07); color: white; }

      /* Divider */
      .divider {
        width: 3px;
        background: linear-gradient(to bottom, #e50914, #831010);
        flex-shrink: 0;
        z-index: 10;
      }

      /* ══════════════════════════════════
         RIGHT SIDE — LOGIN
      ══════════════════════════════════ */
      .right-panel {
        width: 400px;
        flex-shrink: 0;
        position: relative;
        overflow: hidden;
        display: flex;
        flex-direction: column;
      }

      .right-bg {
        position: absolute;
        inset: 0;
        background:
          linear-gradient(rgba(0,0,0,0.72), rgba(0,0,0,0.72)),
          url('https://assets.nflxext.com/ffe/siteui/vlv3signinui/a0c1c90a-5963-4d73-b9bb-c96e11a4f33e/IN-en-20231009-popsignuptwoweeks-perspective_alpha_website_large.jpg')
          center / cover no-repeat;
        z-index: 0;
      }

      /* Right Navbar */
      .right-logo {
        position: relative;
        z-index: 2;
        padding: 20px 26px 10px;
      }

      .right-logo img { height: 30px; }

      /* ── Profile Welcome Card ── */
      .profile-welcome {
        position: relative;
        z-index: 2;
        margin: 10px 26px 0;
        background: rgba(255,255,255,0.07);
        border: 1px solid rgba(255,255,255,0.12);
        border-radius: 10px;
        padding: 18px 16px;
        display: flex;
        align-items: center;
        gap: 14px;
        backdrop-filter: blur(8px);
      }

      .profile-avatar {
        width: 64px;
        height: 64px;
        border-radius: 8px;
        object-fit: cover;
        object-position: center; /* FIXED: full picture */
        flex-shrink: 0;
        border: 2px solid #e50914;
      }

      .profile-info { flex: 1; min-width: 0; }

      .profile-info .greet {
        font-size: 11px;
        color: #aaa;
        margin-bottom: 3px;
        letter-spacing: 0.5px;
        text-transform: uppercase;
      }

      .profile-info .name {
        font-size: 18px;
        font-weight: 800;
        color: white;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }

      .profile-info .tag {
        margin-top: 5px;
        font-size: 11px;
        color: #e50914;
        font-weight: 600;
        letter-spacing: 0.4px;
      }

      .profile-badge {
        background: #e50914;
        color: white;
        font-size: 9px;
        font-weight: 700;
        padding: 3px 7px;
        border-radius: 20px;
        letter-spacing: 0.8px;
        flex-shrink: 0;
        align-self: flex-start;
        margin-top: 2px;
      }

      /* Form area */
      .form-area {
        position: relative;
        z-index: 2;
        flex: 1;
        display: flex;
        flex-direction: column;
        justify-content: flex-end;
      }

      .form-box {
        background: rgba(0,0,0,0.88);
        padding: 24px 26px 22px;
      }

      .form-box h2 {
        font-size: 18px;
        font-weight: 700;
        color: white;
        margin-bottom: 16px;
      }

      .form-control {
        position: relative;
        margin-bottom: 11px;
      }

      .form-control input {
        width: 100%;
        padding: 20px 14px 7px;
        background: #333;
        border: none;
        border-radius: 4px;
        color: white;
        font-size: 14px;
        outline: none;
        transition: background 0.2s;
      }

      .form-control input:focus { background: #454545; }
      .form-control input::placeholder { color: transparent; }

      .form-control label {
        position: absolute;
        top: 14px; left: 14px;
        color: #aaa;
        font-size: 14px;
        transition: all 0.2s;
        pointer-events: none;
      }

      .form-control input:focus + label,
      .form-control input:not(:placeholder-shown) + label {
        top: 5px;
        font-size: 10px;
      }

      .btn-signin {
        width: 100%;
        padding: 13px;
        background: #e50914;
        border: none;
        border-radius: 4px;
        color: white;
        font-size: 14px;
        font-weight: 700;
        cursor: pointer;
        margin-top: 14px;
        margin-bottom: 10px;
        transition: background 0.2s;
      }

      .btn-signin:hover { background: #f40612; }

      .form-help {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 8px;
      }

      .remember-me {
        display: flex;
        align-items: center;
        gap: 5px;
        font-size: 12px;
        color: #b3b3b3;
      }

      .remember-me input { accent-color: #aaa; }

      .form-help a {
        color: #b3b3b3;
        font-size: 12px;
        text-decoration: none;
      }

      .form-help a:hover { text-decoration: underline; }

      .form-box p {
        margin-top: 10px;
        color: #737373;
        font-size: 12px;
      }

      .form-box p a { color: white; text-decoration: none; }
      .form-box p a:hover { text-decoration: underline; }

      .form-box small {
        display: block;
        margin-top: 10px;
        color: #8c8c8c;
        font-size: 11px;
        line-height: 1.5;
      }

      .form-box small a { color: #0071eb; text-decoration: none; }
    </style>
  </head>
  <body>

    <!-- ══════════════════════════════
         LEFT — HOME PANEL
    ══════════════════════════════ -->
    <div class="left-panel">

      <!-- Navbar -->
      <nav class="navbar">
        <img class="logo"
          src="https://upload.wikimedia.org/wikipedia/commons/0/08/Netflix_2015_logo.svg"
          alt="Netflix"
        />
        <div class="nav-right">
          <a href="#">Home</a>
          <a href="#">TV Shows</a>
          <a href="#">Movies</a>
          <a href="#">New &amp; Popular</a>
          <div class="nav-profile">
            <img
              src="https://res.cloudinary.com/dfm3dtqie/image/upload/v1773251648/ask4lcbuvuj0bi9rbmdh.jpg"
              alt="Damodar"
            />
            <span>Damodar</span>
          </div>
        </div>
      </nav>

      <!-- Hero -->
      <div class="hero">
        <img class="hero-bg"
          src="https://assets.nflxext.com/ffe/siteui/vlv3signinui/a0c1c90a-5963-4d73-b9bb-c96e11a4f33e/IN-en-20231009-popsignuptwoweeks-perspective_alpha_website_large.jpg"
          alt="Netflix Background"
        />
        <div class="hero-overlay"></div>
        <div class="hero-content">
          <div class="hero-badge">N SERIES</div>
          <h1>Damodar</h1>
          <p>A thrilling journey of a passionate developer building CI/CD pipelines, conquering Jenkins, and deploying dreams to production.</p>
          <div class="hero-buttons">
            <button class="btn-play">&#9654; Play</button>
            <button class="btn-info">&#8505; More Info</button>
          </div>
        </div>
      </div>

      <!-- Rows -->
      <div class="rows-section">

        <!-- Continue Watching -->
        <div class="row">
          <p class="row-title">Continue Watching for Damodar</p>
          <div class="row-cards">

            <div class="cw-card">
              <div class="cw-thumb">
                <img
                  src="https://res.cloudinary.com/dfm3dtqie/image/upload/v1773251648/ask4lcbuvuj0bi9rbmdh.jpg"
                  alt="Damodar Ep 1"
                />
                <div class="progress-bar">
                  <div class="progress-fill" style="width:60%;"></div>
                </div>
                <div class="play-overlay">
                  <div class="play-circle">&#9654;</div>
                </div>
              </div>
              <p class="cw-label">Damodar &bull; Ep 1</p>
            </div>

            <div class="color-card">
              <div class="color-thumb" style="background:#e50914;">Jenkins Hero</div>
              <p class="color-label">Ep 4</p>
            </div>

            <div class="color-card">
              <div class="color-thumb" style="background:#185FA5;">Pipeline Master</div>
              <p class="color-label">Ep 7</p>
            </div>

            <div class="color-card">
              <div class="color-thumb" style="background:#0F6E56;">Deploy Day</div>
              <p class="color-label">Ep 2</p>
            </div>

            <div class="color-card">
              <div class="color-thumb" style="background:#712B13;">Maven Build</div>
              <p class="color-label">Ep 9</p>
            </div>

          </div>
        </div>

        <!-- Top Picks -->
        <div class="row">
          <p class="row-title">Top Picks for Damodar</p>
          <div class="row-cards">
            <div class="pick-card" style="background:#1a1a2e;">DevOps Nights</div>
            <div class="pick-card" style="background:#16213e;">Git &amp; Chill</div>
            <div class="pick-card" style="background:#0f3460;">Docker Dreams</div>
            <div class="pick-card" style="background:#1b1b2f;">Kubernetes Chronicles</div>
            <div class="pick-card" style="background:#162447;">AWS Nights</div>
            <div class="pick-card" style="background:#2d1b4e;">Terraform Tales</div>
            <div class="pick-card" style="background:#1a2e1a;">Ansible Adventures</div>
          </div>
        </div>

      </div>
    </div>

    <!-- Divider -->
    <div class="divider"></div>

    <!-- ══════════════════════════════
         RIGHT — LOGIN PANEL
    ══════════════════════════════ -->
    <div class="right-panel">
      <div class="right-bg"></div>

      <!-- Logo -->
      <div class="right-logo">
        <a href="#">
          <img src="https://upload.wikimedia.org/wikipedia/commons/0/08/Netflix_2015_logo.svg" alt="Netflix" />
        </a>
      </div>

      <!-- Profile Welcome Card (replaces video container) -->
      <div class="profile-welcome">
        <img
          class="profile-avatar"
          src="https://res.cloudinary.com/dfm3dtqie/image/upload/v1773251648/ask4lcbuvuj0bi9rbmdh.jpg"
          alt="Damodar"
        />
        <div class="profile-info">
          <p class="greet">Welcome back</p>
          <p class="name">Damodar</p>
          <p class="tag">&#9654; DevOps Journey • Season 1</p>
        </div>
        <div class="profile-badge">PRO</div>
      </div>

      <!-- Form -->
      <div class="form-area">
        <div class="form-box">
          <h2>Sign In</h2>
          <form onsubmit="return false;">

            <div class="form-control">
              <input type="text" id="email" placeholder=" " required />
              <label for="email">Email or Mobile number</label>
            </div>

            <div class="form-control">
              <input type="password" id="password" placeholder=" " required />
              <label for="password">Password</label>
            </div>

            <button type="submit" class="btn-signin">Sign In</button>

            <div class="form-help">
              <div class="remember-me">
                <input type="checkbox" id="remember-me" />
                <label for="remember-me">Remember me</label>
              </div>
              <a href="#">Need help?</a>
            </div>
          </form>

          <p>New to Netflix? <a href="#">Join now</a></p>
          <small>
            This page is protected by Google reCAPTCHA to ensure you're not a bot.
            <a href="#">Learn more.</a>
          </small>
        </div>
      </div>

    </div>

    <script>
      document.querySelectorAll('.form-control input').forEach(input => {
        const label = input.nextElementSibling;
        input.addEventListener('focus', () => {
          label.style.top = '5px';
          label.style.fontSize = '10px';
        });
        input.addEventListener('blur', () => {
          if (!input.value) {
            label.style.top = '14px';
            label.style.fontSize = '14px';
          }
        });
      });
    </script>

  </body>
</html>
