/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.zenijah.utils;

/**
 *
 * @author kay
 */

import java.sql.Connection;
import java.sql.SQLException;

public class TestDBConnection {
   public TestDBConnection() {
   }

   public static void main(String[] var0) {
      try {
         Connection var1 = DBConnection.getConnection();
         if (var1 != null) {
            System.out.println("✅ Database connection successful!");
            var1.close();
         } else {
            System.out.println("❌ Failed to establish database connection.");
         }
      } catch (SQLException var2) {
         var2.printStackTrace();
      }

   }
}
