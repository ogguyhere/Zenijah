package com.zenijah.servlets;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

//for date 
import java.text.ParseException;
import java.text.SimpleDateFormat;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import com.zenijah.utils.DBConnection;

@WebServlet("/process-challenge-upload")
@MultipartConfig
public class ProcessChallengeUploadServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        Boolean isAdmin = (Boolean) session.getAttribute("is_admin");

        if (isAdmin == null || !isAdmin) {
            response.sendRedirect("login.jsp");
            return;
        }

        String title = request.getParameter("title");
        String challengeDate = request.getParameter("date");
        
        // FIXED DATE PROBLEM 
        java.sql.Date sqlDate;
        try{
            SimpleDateFormat inputFormat = new SimpleDateFormat("yy-MM-dd");
            java.util.Date parsed = inputFormat.parse(challengeDate);
            sqlDate = new java.sql.Date(parsed.getTime());
                       
        } catch (ParseException e ){
            response.getWriter().println("Invalid date format");
            return;
        }
        
        Part filePart = request.getPart("challenge_image");
        if (filePart == null) {
            response.getWriter().println("Error: File part is null.");
            return;
        }

        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String uploadDir = getServletContext().getRealPath("/") + "uploads/";
        new File(uploadDir).mkdirs(); // Ensure directory exists

        String fullPath = uploadDir + fileName;
        filePart.write(fullPath);

        String imageUrl = "uploads/" + fileName;

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO daily_challenges (title, image_url, challenge_date) VALUES (?, ?, ?)");
            ps.setString(1, title);
            ps.setString(2, imageUrl);
            ps.setDate(3, sqlDate);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Database error.");
            return;
        }

        response.getWriter().println("<p>Challenge uploaded successfully!</p>");
        response.getWriter().println("<a href='admin-upload-challenge.jsp'>Upload another</a>");
    }
}
