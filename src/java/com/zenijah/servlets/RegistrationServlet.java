/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.zenijah.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import com.zenijah.utils.DBConnection;
import org.mindrot.jbcrypt.BCrypt;  // Import BCrypt



@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        int age = Integer.parseInt(request.getParameter("age"));
        String dob = request.getParameter("dob"); // Format: yyyy-MM-dd

        // Hash the password
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO Users (username, email, password, age, dob) VALUES (?, ?, ?, ?, ?)"
            );
            stmt.setString(1, username);
            stmt.setString(2, email);
            stmt.setString(3, hashedPassword);
            stmt.setInt(4, age);
            stmt.setString(5, dob);  // Ensure dob is in proper SQL DATE format
            stmt.executeUpdate();
            conn.close();
            response.sendRedirect("login.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.print(e);
            response.sendRedirect("register.jsp?error=Registration failed. Please try again.");
        }
    }
}
