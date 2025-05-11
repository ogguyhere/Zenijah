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
/**
 *
 * @author kay
 */
@MultipartConfig
@WebServlet(name = "DoodleServlet", urlPatterns = {"/DoodleServlet"})
public class DoodleServlet extends HttpServlet {
     

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        Boolean isAdmin = (Boolean) session.getAttribute("is_admin");

        if (isAdmin == null || !isAdmin) {
            response.sendRedirect("login.jsp");
            return;
        }
        String title = request.getParameter("title");
        System.out.println("title from doodle servlet"+title);

        Part filePart = request.getPart("challenge_image");
        System.out.println("file part from doodle servlet"+filePart);
        if(filePart == null)
        {
            response.getWriter().println("Error: File part is null.");
            return;
        } 
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String uploadDir = getServletContext().getRealPath("/") + "uploads/";
        new File(uploadDir).mkdirs();
        String fullPath = uploadDir + fileName;
        filePart.write(fullPath);
        
        String imageUrl = "uploads/" + fileName;
        
        try(Connection conn = DBConnection.getConnection())
        {
            PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO doodles(title, image_url) VALUES (?,?)");
            ps.setString(1, title);
            ps.setString(2, imageUrl);
            ps.executeUpdate();
        }
        catch(SQLException e)
        {
            e.printStackTrace();
            response.getWriter().println("Database error.");
            return;
        }
        response.getWriter().println("<p> Doodle Uploaded Successfully! </p>");
        response.getWriter().println("<a> href = 'admin-dashboard.jsp'> Admin-Dashboard</a>");
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
