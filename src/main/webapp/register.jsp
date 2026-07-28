<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String error = (String) request.getAttribute("error");
    String success = request.getParameter("success");

    String fullName = request.getAttribute("fullName") != null ? (String) request.getAttribute("fullName") : "";
    String email = request.getAttribute("email") != null ? (String) request.getAttribute("email") : "";
    String phoneNumber = request.getAttribute("phoneNumber") != null ? (String) request.getAttribute("phoneNumber") : "";
    String street = request.getAttribute("street") != null ? (String) request.getAttribute("street") : "";
    String landmark = request.getAttribute("landmark") != null ? (String) request.getAttribute("landmark") : "";
    String city = request.getAttribute("city") != null ? (String) request.getAttribute("city") : "";
    String state = request.getAttribute("state") != null ? (String) request.getAttribute("state") : "";
    String pincode = request.getAttribute("pincode") != null ? (String) request.getAttribute("pincode") : "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Create Account | SwiftByte</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="https://fonts.googleapis.com/css2?family=Instrument+Serif:ital@0;1&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<style>
    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
    }

    body {
        min-height: 100vh;
        font-family: 'Inter', sans-serif;
        background: #fff8ef;
        color: #1f1f1f;
    }

    .page {
        min-height: 100vh;
        display: grid;
        grid-template-columns: 0.95fr 1.05fr;
    }

    .visual-side {
        background:
            radial-gradient(circle at top left, rgba(255, 107, 0, 0.22), transparent 35%),
            linear-gradient(135deg, #fff3df, #fff8ef);
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 48px;
    }

    .image-card {
        width: min(440px, 100%);
        height: 560px;
        background: #ffffff;
        border-radius: 28px;
        padding: 18px;
        box-shadow: 0 28px 80px rgba(255, 107, 0, 0.18);
        position: relative;
        overflow: hidden;
    }

    .image-box {
        width: 100%;
        height: 100%;
        border-radius: 22px;
        overflow: hidden;
        position: relative;
        background:
            linear-gradient(to bottom, rgba(0,0,0,0.03), rgba(0,0,0,0.35)),
            url("https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=900&q=80");
        background-size: cover;
        background-position: center;
    }

    .image-content {
        position: absolute;
        left: 24px;
        right: 24px;
        bottom: 24px;
        background: rgba(255,255,255,0.92);
        backdrop-filter: blur(14px);
        border-radius: 20px;
        padding: 22px;
        box-shadow: 0 14px 40px rgba(0,0,0,0.12);
    }

    .image-content h2 {
        font-family: 'Instrument Serif', serif;
        font-size: 34px;
        line-height: 1;
        margin-bottom: 10px;
    }

    .image-content p {
        color: #6f6258;
        font-size: 14px;
        line-height: 1.6;
    }

    .form-side {
        background: #fffdf9;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 44px;
    }

    .form-wrap {
        width: min(620px, 100%);
    }

    .brand {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 26px;
        color: #ff6b00;
        font-weight: 800;
        font-size: 22px;
    }

    .brand-badge {
        width: 34px;
        height: 34px;
        border-radius: 11px;
        background: #ff6b00;
        color: #ffffff;
        display: grid;
        place-items: center;
        font-weight: 900;
    }

    h1 {
        font-family: 'Instrument Serif', serif;
        font-size: clamp(44px, 5vw, 62px);
        font-weight: 400;
        line-height: 0.95;
        margin-bottom: 10px;
    }

    .subtitle {
        color: #786d64;
        margin-bottom: 28px;
        font-size: 16px;
    }

    .alert {
        padding: 14px 16px;
        border-radius: 14px;
        margin-bottom: 20px;
        font-size: 14px;
        font-weight: 700;
    }

    .alert-error {
        background: #fff0f0;
        color: #c40000;
        border: 1px solid #ffc6c6;
    }

    .alert-success {
        background: #eafaf0;
        color: #157347;
        border: 1px solid #b7ebc6;
    }

    form {
        display: grid;
        gap: 16px;
    }

    .grid-2 {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 14px;
    }

    .field {
        display: flex;
        flex-direction: column;
        gap: 8px;
    }

    label {
        font-size: 13px;
        font-weight: 800;
        color: #201a16;
    }

    input {
        width: 100%;
        height: 54px;
        border-radius: 15px;
        border: 1px solid #eadfd5;
        background: #ffffff;
        padding: 0 16px;
        font-size: 15px;
        color: #1f1f1f;
        outline: none;
        transition: 0.2s ease;
    }

    input:focus {
        border-color: #ff6b00;
        box-shadow: 0 0 0 4px rgba(255, 107, 0, 0.12);
    }

    .password-box {
        position: relative;
    }

    .password-box input {
        padding-right: 52px;
    }

    .eye-btn {
        position: absolute;
        right: 14px;
        top: 50%;
        transform: translateY(-50%);
        border: none;
        background: transparent;
        cursor: pointer;
        color: #7a7068;
        font-size: 18px;
    }

    .help {
        display: none;
        font-size: 12px;
        color: #c40000;
        font-weight: 600;
    }

    .field.invalid input {
        border-color: #ff9d9d;
        background: #fffafa;
    }

    .field.invalid .help {
        display: block;
    }

    .strength {
        height: 5px;
        border-radius: 999px;
        background: #eee2d8;
        overflow: hidden;
        margin-top: 8px;
    }

    .strength span {
        display: block;
        height: 100%;
        width: 0%;
        background: #ff3b30;
        transition: 0.2s ease;
    }

    .submit-btn {
        height: 58px;
        border-radius: 16px;
        border: none;
        background: #ff6b00;
        color: #ffffff;
        font-size: 16px;
        font-weight: 900;
        cursor: pointer;
        margin-top: 8px;
        box-shadow: 0 16px 32px rgba(255, 107, 0, 0.24);
        transition: 0.2s ease;
    }

    .submit-btn:hover {
        background: #e85f00;
        transform: translateY(-1px);
    }

    .alt {
        text-align: center;
        margin-top: 18px;
        color: #74685f;
        font-size: 14px;
    }

    .alt a {
        color: #ff6b00;
        text-decoration: none;
        font-weight: 900;
        margin-left: 5px;
    }

    @media (max-width: 950px) {
        .page {
            grid-template-columns: 1fr;
        }

        .visual-side {
            display: none;
        }

        .form-side {
            padding: 28px 18px;
        }
    }

    @media (max-width: 620px) {
        .grid-2 {
            grid-template-columns: 1fr;
        }

        h1 {
            font-size: 44px;
        }
    }
</style>
</head>

<body>

<div class="page">

    <section class="visual-side">
        <div class="image-card">
            <div class="image-box">
                <div class="image-content">
                    <h2>Fresh meals, faster.</h2>
                    <p>Create your SwiftByte account and order from your favourite restaurants in minutes.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="form-side">
        <div class="form-wrap">

            <div class="brand">
                <div class="brand-badge">S</div>
                SwiftByte
            </div>

            <h1>Create your account</h1>
            <p class="subtitle">Join SwiftByte in less than a minute.</p>

            <% if (error != null && !error.trim().isEmpty()) { %>
                <div class="alert alert-error"><%= error %></div>
            <% } %>

            <% if ("registered".equals(success)) { %>
                <div class="alert alert-success">Account created successfully. Please sign in.</div>
            <% } %>

            <form id="registerForm" action="<%= request.getContextPath() %>/register" method="post" novalidate>

                <div class="field" id="field-fullName">
                    <label for="fullName">Full name</label>
                    <input type="text" id="fullName" name="fullName" value="<%= fullName %>" autocomplete="name">
                    <small class="help">Enter your full name.</small>
                </div>

                <div class="field" id="field-email">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" value="<%= email %>" autocomplete="email">
                    <small class="help">Enter a valid email address.</small>
                </div>

                <div class="grid-2">
                    <div class="field" id="field-phoneNumber">
                        <label for="phoneNumber">Phone</label>
                        <input
                            type="tel"
                            id="phoneNumber"
                            name="phoneNumber"
                            value="<%= phoneNumber %>"
                            placeholder="10-digit mobile"
                            maxlength="10"
                            inputmode="numeric"
                            autocomplete="tel">
                        <small class="help">Enter a valid 10-digit Indian mobile number.</small>
                    </div>

                    <div class="field" id="field-password">
                        <label for="password">Password</label>
                        <div class="password-box">
                            <input type="password" id="password" name="password" autocomplete="new-password">
                            <button type="button" class="eye-btn" id="togglePassword">👁</button>
                        </div>
                        <div class="strength"><span id="strengthBar"></span></div>
                        <small class="help">Use 8+ chars with uppercase, lowercase, number and special character.</small>
                    </div>
                </div>

                <div class="field" id="field-street">
                    <label for="street">Street / House / Area</label>
                    <input type="text" id="street" name="street" value="<%= street %>" autocomplete="address-line1">
                    <small class="help">Enter your street, house number or area.</small>
                </div>

                <div class="grid-2">
                    <div class="field" id="field-landmark">
                        <label for="landmark">Landmark optional</label>
                        <input type="text" id="landmark" name="landmark" value="<%= landmark %>" autocomplete="address-line2">
                    </div>

                    <div class="field" id="field-city">
                        <label for="city">City</label>
                        <input type="text" id="city" name="city" value="<%= city %>" autocomplete="address-level2">
                        <small class="help">Enter your city.</small>
                    </div>
                </div>

                <div class="grid-2">
                    <div class="field" id="field-state">
                        <label for="state">State</label>
                        <input type="text" id="state" name="state" value="<%= state %>" autocomplete="address-level1">
                        <small class="help">Enter your state.</small>
                    </div>

                    <div class="field" id="field-pincode">
                        <label for="pincode">PIN code</label>
                        <input type="text" id="pincode" name="pincode" value="<%= pincode %>" maxlength="6" inputmode="numeric" autocomplete="postal-code">
                        <small class="help">Enter a valid 6-digit PIN code.</small>
                    </div>
                </div>

                <button type="submit" class="submit-btn">Create account</button>
            </form>

            <p class="alt">
                Already have an account?
                <a href="<%= request.getContextPath() %>/login.jsp">Sign in</a>
            </p>

        </div>
    </section>

</div>

<script>
    const form = document.getElementById("registerForm");

    const fullName = document.getElementById("fullName");
    const email = document.getElementById("email");
    const phoneNumber = document.getElementById("phoneNumber");
    const password = document.getElementById("password");
    const street = document.getElementById("street");
    const city = document.getElementById("city");
    const state = document.getElementById("state");
    const pincode = document.getElementById("pincode");

    const togglePassword = document.getElementById("togglePassword");
    const strengthBar = document.getElementById("strengthBar");

    let submitted = false;

    function cleanSpaces(value) {
        return value.trim().replace(/\s+/g, " ");
    }

    function setInvalid(input, invalid) {
        const field = document.getElementById("field-" + input.id);
        if (!field) return;

        if (invalid) {
            field.classList.add("invalid");
        } else {
            field.classList.remove("invalid");
        }
    }

    function validateFullName(show) {
        const value = cleanSpaces(fullName.value);
        const valid = /^[A-Za-z ]{3,60}$/.test(value);
        if (show) setInvalid(fullName, !valid);
        return valid;
    }

    function validateEmail(show) {
        const value = email.value.trim();
        const valid = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(value) && value.length <= 100;
        if (show) setInvalid(email, !valid);
        return valid;
    }

    function validatePhone(show) {
        const value = phoneNumber.value.trim();
        const valid = /^[6-9][0-9]{9}$/.test(value);
        if (show) setInvalid(phoneNumber, !valid);
        return valid;
    }

    function validatePassword(show) {
        const value = password.value;
        const valid =
            value.length >= 8 &&
            /[A-Z]/.test(value) &&
            /[a-z]/.test(value) &&
            /[0-9]/.test(value) &&
            /[^A-Za-z0-9]/.test(value);

        if (show) setInvalid(password, !valid);
        return valid;
    }

    function validateStreet(show) {
        const value = cleanSpaces(street.value);
        const valid = value.length >= 5 && value.length <= 150;
        if (show) setInvalid(street, !valid);
        return valid;
    }

    function validateCity(show) {
        const value = cleanSpaces(city.value);
        const valid = /^[A-Za-z ]{2,50}$/.test(value);
        if (show) setInvalid(city, !valid);
        return valid;
    }

    function validateState(show) {
        const value = cleanSpaces(state.value);
        const valid = /^[A-Za-z ]{2,50}$/.test(value);
        if (show) setInvalid(state, !valid);
        return valid;
    }

    function validatePincode(show) {
        const value = pincode.value.trim();
        const valid = /^[1-9][0-9]{5}$/.test(value);
        if (show) setInvalid(pincode, !valid);
        return valid;
    }

    function validateAll(show) {
        let ok = true;

        ok = validateFullName(show) && ok;
        ok = validateEmail(show) && ok;
        ok = validatePhone(show) && ok;
        ok = validatePassword(show) && ok;
        ok = validateStreet(show) && ok;
        ok = validateCity(show) && ok;
        ok = validateState(show) && ok;
        ok = validatePincode(show) && ok;

        return ok;
    }

    phoneNumber.addEventListener("input", function () {
        this.value = this.value.replace(/\D/g, "").slice(0, 10);
        if (submitted) validatePhone(true);
    });

    pincode.addEventListener("input", function () {
        this.value = this.value.replace(/\D/g, "").slice(0, 6);
        if (submitted) validatePincode(true);
    });

    [fullName, email, password, street, city, state].forEach(function (input) {
        input.addEventListener("input", function () {
            if (submitted) validateAll(true);
        });
    });

    password.addEventListener("input", function () {
        const value = password.value;
        let score = 0;

        if (value.length >= 8) score++;
        if (/[A-Z]/.test(value)) score++;
        if (/[a-z]/.test(value)) score++;
        if (/[0-9]/.test(value)) score++;
        if (/[^A-Za-z0-9]/.test(value)) score++;

        const percent = score * 20;
        strengthBar.style.width = percent + "%";

        if (score <= 2) {
            strengthBar.style.background = "#ff3b30";
        } else if (score <= 4) {
            strengthBar.style.background = "#ff9500";
        } else {
            strengthBar.style.background = "#20c997";
        }
    });

    togglePassword.addEventListener("click", function () {
        if (password.type === "password") {
            password.type = "text";
            togglePassword.textContent = "🙈";
        } else {
            password.type = "password";
            togglePassword.textContent = "👁";
        }
    });

    form.addEventListener("submit", function (e) {
        submitted = true;

        const valid = validateAll(true);

        if (!valid) {
            e.preventDefault();
        }
    });
</script>

</body>
</html>
