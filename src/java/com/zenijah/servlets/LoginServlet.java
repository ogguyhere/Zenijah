package com.zenijah.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.zenijah.utils.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM Users WHERE email = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
           


            if (rs.next()) {
                String storedPasswordHash = rs.getString("password");
                boolean isAdmin = rs.getBoolean("is_admin");  // make sure this column exists in your DB
                 int user_id = rs.getInt("id");
                 if (rs.wasNull()) {
    // id is null
    System.out.println("User ID is null.");
} else {
    // id is not null
    System.out.println("User ID: " + user_id);
}

                if (BCrypt.checkpw(password, storedPasswordHash)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("email", email);
                    session.setAttribute("is_admin", isAdmin);
                    session.setAttribute("id",user_id );
                    session.setAttribute("dob", rs.getDate("dob"));
                    session.setAttribute("username",rs.getString("username")); 
                    

                    if (isAdmin) {
                        response.sendRedirect("admin-dashboard.jsp");
                    } else {
                        response.sendRedirect("user-dashboard.jsp");
                    }
                } else {
                    response.getWriter().println("Invalid email or password.");
                }
            } else {
                response.getWriter().println("Invalid email or password.");
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Login failed. Please try again.");
        }
    }
}
