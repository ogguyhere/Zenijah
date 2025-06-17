package com.zenijah.api;

import java.io.*;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.json.JSONObject;
import com.zenijah.utils.DBConnection;

@WebServlet(name = "UserProfileAPI", urlPatterns = {"/api/profile"})
public class UserProfileAPI extends HttpServlet {

    // GET: Retrieve current user's profile
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        String sessionEmail = (String) request.getSession().getAttribute("email");
        if (sessionEmail == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(new JSONObject().put("error", "Not logged in"));
            out.flush();
            return;
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT username, email, age, dob FROM Users WHERE email = ?")) {

            stmt.setString(1, sessionEmail);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                JSONObject user = new JSONObject();
                user.put("name", rs.getString("username"));
                user.put("email", rs.getString("email"));
                user.put("age", rs.getInt("age"));
                user.put("dob", rs.getString("dob"));
                out.print(user.toString());
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print(new JSONObject().put("error", "User not found"));
            }

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(new JSONObject().put("error", "Database error: " + e.getMessage()));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(new JSONObject().put("error", "Unexpected error: " + e.getMessage()));
        }
        out.flush();
    }

    // PUT: Update current user's profile
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        String sessionEmail = (String) request.getSession().getAttribute("email");
        if (sessionEmail == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(new JSONObject().put("error", "Not logged in"));
            out.flush();
            return;
        }

        StringBuilder buffer = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                buffer.append(line);
            }
        } catch (IOException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(new JSONObject().put("error", "Failed to read request body"));
            out.flush();
            return;
        }

        try {
            JSONObject input = new JSONObject(buffer.toString());
            String name = input.optString("name", null);
            int age = input.optInt("age", -1);
            String dob = input.optString("dob", null);

            // Validate inputs
            if (name == null || name.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(new JSONObject().put("error", "Name is required"));
                out.flush();
                return;
            }
            if (age <= 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(new JSONObject().put("error", "Valid age is required"));
                out.flush();
                return;
            }
            if (dob == null || !dob.matches("\\d{4}-\\d{2}-\\d{2}")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(new JSONObject().put("error", "Valid date of birth (YYYY-MM-DD) is required"));
                out.flush();
                return;
            }

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(
                         "UPDATE Users SET username = ?, age = ?, dob = ? WHERE email = ?")) {

                stmt.setString(1, name.trim());
                stmt.setInt(2, age);
                stmt.setDate(3, java.sql.Date.valueOf(dob));
                stmt.setString(4, sessionEmail);

                int rows = stmt.executeUpdate();
                if (rows > 0) {
                    HttpSession session = request.getSession();
                    session.setAttribute("username", name.trim());
                    session.setAttribute("age", age);
                    session.setAttribute("dob", java.sql.Date.valueOf(dob));

                    JSONObject res = new JSONObject();
                    res.put("email", sessionEmail);
                    res.put("status", "updated");
                    out.print(res.toString());
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print(new JSONObject().put("error", "User not found"));
                }

            } catch (SQLException e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(new JSONObject().put("error", "Database error: " + e.getMessage()));
            }

        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(new JSONObject().put("error", "Invalid date format"));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(new JSONObject().put("error", "Invalid input: " + e.getMessage()));
        }

        out.flush();
    }

    // DELETE: Delete current user's account
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        String sessionEmail = (String) request.getSession().getAttribute("email");
        if (sessionEmail == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(new JSONObject().put("error", "Not logged in"));
            out.flush();
            return;
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("DELETE FROM Users WHERE email = ?")) {

            stmt.setString(1, sessionEmail);
            int rows = stmt.executeUpdate();

            if (rows > 0) {
                request.getSession().invalidate();
                out.print(new JSONObject().put("status", "account deleted"));
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print(new JSONObject().put("error", "User not found"));
            }

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(new JSONObject().put("error", "Database error: " + e.getMessage()));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(new JSONObject().put("error", "Unexpected error: " + e.getMessage()));
        }

        out.flush();
    }
}