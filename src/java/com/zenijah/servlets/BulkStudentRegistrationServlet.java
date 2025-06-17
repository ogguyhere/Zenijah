package com.zenijah.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.BufferedReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;
import com.zenijah.utils.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet(name = "BulkStudentRegistrationServlet", urlPatterns = {"/BulkStudentRegistrationServlet"})
public class BulkStudentRegistrationServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        StringBuilder jsonBuffer = new StringBuilder();
        String line;

        // Read the JSON input
        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                jsonBuffer.append(line);
            }
        }

        JSONArray students = new JSONArray(jsonBuffer.toString());
        JSONArray result = new JSONArray();

        try (Connection conn = DBConnection.getConnection()) {
            for (int i = 0; i < students.length(); i++) {
                JSONObject student = students.getJSONObject(i);
                String name = student.getString("name");
                String email = student.getString("email");
                String rawPassword = student.getString("password");
                int age = student.getInt("age");
                String dob = student.getString("dob");

                // 🔐 Hash the password
                String hashedPassword = BCrypt.hashpw(rawPassword, BCrypt.gensalt());

                try (PreparedStatement stmt = conn.prepareStatement(
                        "INSERT INTO Users (username, email, password, age, dob) VALUES (?, ?, ?, ?, ?)")) {
                    stmt.setString(1, name);
                    stmt.setString(2, email);
                    stmt.setString(3, hashedPassword);
                    stmt.setInt(4, age);
                    stmt.setString(5, dob);
                    stmt.executeUpdate();
                      
                    System.out.print(dob);
                    JSONObject success = new JSONObject();
                    success.put("email", email);
                    success.put("status", "registered");
                    result.put(success);

                } catch (SQLException e) {
                    JSONObject fail = new JSONObject();
                    fail.put("email", email);
                    fail.put("status", "failed");
                    fail.put("error", e.getMessage());
                    result.put(fail);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        out.print(result.toString());
        out.flush();
    }
}
