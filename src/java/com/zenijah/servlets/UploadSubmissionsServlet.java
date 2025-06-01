/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.zenijah.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.*;
import java.nio.file.*;
import java.sql.*;

import com.zenijah.utils.DBConnection;

@WebServlet("/uploadSubmission")
@MultipartConfig
public class UploadSubmissionsServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String email = (String) session.getAttribute("email");
        Part filePart = request.getPart("submission");

        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("message", "No file uploaded. Please try again.");
            request.getRequestDispatcher("upload-failed.jsp").forward(request, response);
            return;
        }

        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String uploadDir = getServletContext().getRealPath("/") + "uploads/";
        Files.createDirectories(Paths.get(uploadDir));

        String fullPath = uploadDir + fileName;
        filePart.write(fullPath);
        String submissionUrl = "uploads/" + fileName;

        try (Connection conn = DBConnection.getConnection()) {
            // Get today's challenge ID
            PreparedStatement findChallenge = conn.prepareStatement("SELECT id FROM daily_challenges WHERE challenge_date = CURDATE()");
            ResultSet rs = findChallenge.executeQuery();

            if (!rs.next()) {
                request.setAttribute("message", "No challenge found for today.");
                request.getRequestDispatcher("upload-failed.jsp").forward(request, response);
                return;
            }

            int challengeId = rs.getInt("id");

            PreparedStatement ps = conn.prepareStatement("INSERT INTO challenge_submissions (user_email, challenge_id, submission_url) VALUES (?, ?, ?)");
            ps.setString(1, email);
            ps.setInt(2, challengeId);
            ps.setString(3, submissionUrl);
            ps.executeUpdate();

            request.setAttribute("message", "Submission uploaded successfully!");
            request.getRequestDispatcher("upload-success.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "Database error occurred. Please try again.");
            request.getRequestDispatcher("upload-failed.jsp").forward(request, response);
        }
    }
}
