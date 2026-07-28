<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String error = (String) request.getAttribute("error");
    String prefill = request.getParameter("email");
    if (prefill == null) prefill = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>SwiftByte — Login</title>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
  *{box-sizing:border-box;margin:0;padding:0;font-family:'Inter',sans-serif}
  body{min-height:100vh;background:#fcfbf8;display:flex;align-items:center;justify-content:center;padding:24px}
  .shell{width:100%;max-width:1080px;background:#fff;border-radius:24px;overflow:hidden;
         box-shadow:0 30px 80px -30px rgba(60,30,10,.25);display:grid;grid-template-columns:1.1fr 1fr;min-height:640px}
  .hero{position:relative;background:
        linear-gradient(135deg,rgba(30,15,5,.55),rgba(30,15,5,.15)),
        url('https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=1200&q=80') center/cover;
        color:#fff;padding:48px;display:flex;flex-direction:column;justify-content:space-between}
  .brand{font-family:'Playfair Display',serif;font-size:26px;letter-spacing:.5px}
  .brand span{color:#ff8a3d}
  .hero h1{font-family:'Playfair Display',serif;font-size:56px;line-height:1.05;font-weight:800;margin-bottom:18px}
  .hero p{font-size:15px;line-height:1.6;max-width:420px;color:#f5e9dc}
  .hero .foot{font-size:12px;color:#f5e9dc;opacity:.85}
  .panel{padding:56px 52px;display:flex;flex-direction:column;justify-content:center;background:#fff}
  .panel .logo{text-align:center;font-family:'Playfair Display',serif;font-size:28px;font-weight:800;color:#1a1a1a;margin-bottom:8px}
  .panel .logo span{color:#ff8a3d}
  .panel h2{text-align:center;font-family:'Playfair Display',serif;font-size:34px;font-weight:800;
            color:#ff6b1a;margin-bottom:30px}
  .field{background:#f4efe8;border-radius:14px;padding:14px 18px;margin-bottom:16px}
  .field input{width:100%;background:transparent;border:none;outline:none;font-size:15px;color:#2b1d10}
  .field input::placeholder{color:#8a7563}
  .btn{width:100%;background:linear-gradient(135deg,#ff8a3d,#ff6b1a);color:#fff;border:none;padding:15px;
       border-radius:14px;font-size:16px;font-weight:600;cursor:pointer;letter-spacing:.3px;
       box-shadow:0 12px 30px -12px rgba(255,107,26,.6);transition:transform .15s}
  .btn:hover{transform:translateY(-1px)}
  .alt{text-align:center;margin-top:22px;color:#5a4a3b;font-size:14px}
  .alt a{color:#ff6b1a;font-weight:700;text-decoration:none;margin-left:6px}
  .err{background:#ffece1;color:#b0400a;border-left:4px solid #ff6b1a;padding:10px 14px;border-radius:8px;
       margin-bottom:16px;font-size:13.5px}
  @media(max-width:820px){.shell{grid-template-columns:1fr}.hero{min-height:260px;padding:32px}.hero h1{font-size:38px}.panel{padding:36px 28px}}
</style>
</head>
<body>
  <div class="shell">
    <aside class="hero">
      <div class="brand">Swift<span>Byte</span></div>
      <div>
        <h1>Welcome Back!</h1>
        <p>Order from the best restaurants around you. Sign in to continue your delicious journey with SwiftByte.</p>
      </div>
      <div class="foot">Fast delivery · Curated kitchens · Everyday favourites</div>
    </aside>

    <section class="panel">
      <div class="logo">Swift<span>Byte</span></div>
      <h2>Sign In</h2>

      <% if (error != null) { %>
        <div class="err"><%= error %></div>
      <% } %>

      <form method="post" action="login" autocomplete="on">
        <div class="field">
          <input type="email" name="email" placeholder="Email address" required value="<%= prefill %>">
        </div>
        <div class="field">
          <input type="password" name="password" placeholder="Password" required>
        </div>
        <button type="submit" class="btn">Sign In</button>
      </form>

      <p class="alt">New to SwiftByte? <a href="${pageContext.request.contextPath}/register.jsp">Create an account</a></p>
      
    </section>
  </div>
</body>
</html>
