/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.zenijah.servlets;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.Base64;

/**
 *
 * @author kay
 */
@WebServlet("/upload")
public class UploadServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        StringBuilder jsonBuffer = new StringBuilder();
        String line;
        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                jsonBuffer.append(line);
            }
        }

        // Extract base64 string
        String json = jsonBuffer.toString();
        String base64Image = json.split(",")[1].replace("\"", "").replace("}", "").trim(); // crude JSON parsing
        byte[] imageBytes = Base64.getDecoder().decode(base64Image);

        // Save image
        String fileName = "drawing_" + System.currentTimeMillis() + ".png";
        File outputFile = new File(getServletContext().getRealPath("/") + "images/" + fileName);
        outputFile.getParentFile().mkdirs();
        try (FileOutputStream fos = new FileOutputStream(outputFile)) {
            fos.write(imageBytes);
        }

        response.getWriter().write("Image saved successfully.");
    }
}