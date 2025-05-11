/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.zenijah.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.zenijah.utils.DBConnection;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;

/**
 *
 * @author kay
 */
@MultipartConfig
@WebServlet(name = "Process_DoodleServlet", urlPatterns = {"/Process_DoodleServlet"})
public class Process_DoodleServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        if (userId == null) {
    String userIdParam = request.getParameter("user_id");
    if (userIdParam != null) {
        userId = Integer.parseInt(userIdParam);
    } else {
        response.getWriter().println("{\"error\": \"User ID not found.\"}");
        return;
    }
}
        if(userId==null){
            response.sendRedirect("login.jsp");
            return ;
        }
        
        String dataUrl = request.getParameter("doodle");
        int challengeId = Integer.parseInt(request.getParameter("challenge_id"));
        
        //saving doodle 
        String fileName = "doodle_" + userId+ "_" +System.currentTimeMillis() +".png";
        
        String uploadDir = getServletContext().getRealPath("/") +"uploads/";
        
        new File(uploadDir).mkdirs();
        String fullPath = uploadDir + fileName;
        
        //convert to base 64 to image
        String base64Image = dataUrl.split(",")[1];
        byte[] imageBytes = Base64.getDecoder().decode(base64Image);
        BufferedImage doodleImage = ImageIO.read(new ByteArrayInputStream(imageBytes));
        ImageIO.write(doodleImage,"png",new File(fullPath));
        
        String doodleUrl = "uploads/" +fileName;
        
        //Fetch reference iage Url from dooles table 
        String referenceImageUrl = "";
        try (Connection conn= DBConnection.getConnection()){
            PreparedStatement ps = conn.prepareStatement("Select image_url from doodles where id = ?");
            ps.setInt(1, 3);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
            {
                referenceImageUrl = rs.getString("image_url");
            }
        }
        catch(SQLException e){
            e.printStackTrace();
            response.getWriter().println("{\"error\": \"Database error.\" }");
            return;
        }
        
        //Compare Imgs using ai (idek how )
        int rating = compareImages(getServletContext().getRealPath("/")+referenceImageUrl, fullPath);
        
        //Save Submissions 
        try (Connection conn = DBConnection.getConnection()){
            PreparedStatement ps = conn.prepareStatement("INSERT INTO doodle_submissions(challenge_id, user_id, doodle_url, rating)VALUES(?,?,?,?)");
             ps.setInt(1, challengeId);
            ps.setInt(2, userId);
            ps.setString(3, doodleUrl);
            ps.setInt(4, rating);
            ps.executeUpdate();
        }catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("{\"error\": \"Database error.\"}");
            return;
        }
        
        response.getWriter().println("{\"rating\": " + rating + "}");
        
        
    }
    
    private int compareImages(String referencePath, String doodlePath) {
        try {
            BufferedImage img1 = ImageIO.read(new File(referencePath));
            BufferedImage img2 = ImageIO.read(new File(doodlePath));

            // Resize images to same dimensions for comparison
            int width = 400, height = 400;
            BufferedImage resizedImg1 = new BufferedImage(width, height, BufferedImage. TYPE_INT_ARGB);
            BufferedImage resizedImg2 = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
            resizedImg1.getGraphics().drawImage(img1.getScaledInstance(width, height, java.awt.Image.SCALE_SMOOTH), 0, 0, null);
            resizedImg2.getGraphics().drawImage(img2.getScaledInstance(width, height, java.awt.Image.SCALE_SMOOTH), 0, 0, null);

            // Compare pixel differences
            long diff = 0;
            for (int y = 0; y < height; y++) {
                for (int x = 0; x < width; x++) {
                    int rgb1 = resizedImg1.getRGB(x, y);
                    int rgb2 = resizedImg2.getRGB(x, y);
                    int r1 = (rgb1 >> 16) & 0xff;
                    int g1 = (rgb1 >> 8) & 0xff;
                    int b1 = rgb1 & 0xff;
                    int r2 = (rgb2 >> 16) & 0xff;
                    int g2 = (rgb2 >> 8) & 0xff;
                    int b2 = rgb2 & 0xff;
                    diff += Math.abs(r1 - r2) + Math.abs(g1 - g2) + Math.abs(b1 - b2);
                }
            }
            double avgDiff = diff / (width * height * 3.0);
            // Convert difference to rating (lower difference = higher rating)
            int rating = (int) Math.max(0, 10 - (avgDiff / 25.5)); // Scale to 0-10
            return rating;
        } catch (IOException e) {
            e.printStackTrace();
            return 5; // Default rating on error
        }
    }
    

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
