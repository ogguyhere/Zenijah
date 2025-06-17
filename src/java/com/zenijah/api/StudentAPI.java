/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

/**
 *
 * @author kay
 */
package com.zenijah.api;

import java.io.*;
import java.sql.*;
import java.util.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import org.json.JSONArray;
import org.json.JSONObject;
import com.zenijah.utils.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet(name = "StudentAPI", urlPatterns = {"/api/students"})
public class StudentAPI extends HttpServlet {

    // ✅ CREATE (Bulk Insert)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        StringBuilder jsonBuffer = new StringBuilder();
        String line;

        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                jsonBuffer.append(line);
            }
        }

        JSONArray students;
        JSONArray result = new JSONArray();

        try {
            students = new JSONArray(jsonBuffer.toString());
        } catch (Exception ex) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(new JSONObject().put("error", "Invalid JSON format"));
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            for (int i = 0; i < students.length(); i++) {
                JSONObject student = students.getJSONObject(i);
                String name = student.optString("name");
                String email = student.optString("email");
                String rawPassword = student.optString("password");
                int age = student.optInt("age");
                String dob = student.optString("dob");

                String hashedPassword = BCrypt.hashpw(rawPassword, BCrypt.gensalt());

                try (PreparedStatement stmt = conn.prepareStatement(
                        "INSERT INTO Users (username, email, password, age, dob) VALUES (?, ?, ?, ?, ?)")) {
                    stmt.setString(1, name);
                    stmt.setString(2, email);
                    stmt.setString(3, hashedPassword);
                    stmt.setInt(4, age);
                    stmt.setString(5, dob);
                    stmt.executeUpdate();

                    result.put(new JSONObject().put("email", email).put("status", "registered"));
                } catch (SQLException e) {
                    result.put(new JSONObject().put("email", email).put("status", "failed").put("error", e.getMessage()));
                }
            }

            response.setStatus(HttpServletResponse.SC_CREATED);
            out.print(result.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(new JSONObject().put("error", "Internal server error"));
        }
        out.flush();
    }

    // ✅ READ (Get all students)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JSONArray result = new JSONArray();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT id, username, email, age, dob FROM Users");
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                JSONObject student = new JSONObject();
                student.put("id", rs.getInt("id"));
                student.put("name", rs.getString("username"));
                student.put("email", rs.getString("email"));
                student.put("age", rs.getInt("age"));
                student.put("dob", rs.getString("dob"));
                result.put(student);
            }

            out.print(result.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(new JSONObject().put("error", "Could not retrieve students"));
        }
        out.flush();
    }

    // ✅ UPDATE (Update student info by email)
    @Override
protected void doPut(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    response.setContentType("application/json");
    PrintWriter out = response.getWriter();
    StringBuilder buffer = new StringBuilder();
    String line;

    try (BufferedReader reader = request.getReader()) {
        while ((line = reader.readLine()) != null) {
            buffer.append(line);
        }
    }

    try (Connection conn = DBConnection.getConnection()) {
        JSONArray students;

        // Try to parse as array
        try {
            students = new JSONArray(buffer.toString());
        } catch (Exception e) {
            // Not an array? Try as single object
            JSONObject single = new JSONObject(buffer.toString());
            students = new JSONArray().put(single);
        }

        JSONArray result = new JSONArray();

        for (int i = 0; i < students.length(); i++) {
            JSONObject student = students.getJSONObject(i);
            String email = student.optString("email");
            String name = student.optString("name");
            int age = student.optInt("age");
            String dob = student.optString("dob");

            if (email == null || email.isEmpty()) {
                result.put(new JSONObject().put("status", "error").put("message", "Missing email for record " + i));
                continue;
            }

            try (PreparedStatement stmt = conn.prepareStatement(
                    "UPDATE Users SET username=?, age=?, dob=? WHERE email=?")) {
                stmt.setString(1, name);
                stmt.setInt(2, age);
                stmt.setString(3, dob);
                stmt.setString(4, email);

                int rows = stmt.executeUpdate();
                if (rows > 0) {
                    result.put(new JSONObject().put("email", email).put("status", "updated"));
                } else {
                    result.put(new JSONObject().put("email", email).put("status", "not found"));
                }
            } catch (SQLException ex) {
                result.put(new JSONObject().put("email", email).put("status", "failed").put("error", ex.getMessage()));
            }
        }

        out.print(result.toString());

    } catch (Exception e) {
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        out.print(new JSONObject().put("error", "Invalid input or server error"));
    }

    out.flush();
}

    // ✅ DELETE (Delete student by email)
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        String email = request.getParameter("email");

        if (email == null || email.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(new JSONObject().put("error", "Email parameter is required"));
            return;
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("DELETE FROM Users WHERE email = ?")) {
            stmt.setString(1, email);

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                out.print(new JSONObject().put("email", email).put("status", "deleted"));
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print(new JSONObject().put("email", email).put("status", "not found"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(new JSONObject().put("error", "Failed to delete student"));
        }

        out.flush();
    }
}
