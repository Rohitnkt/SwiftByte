package com.swiftbyte.test;

import java.util.Scanner;

import com.swiftbyte.dao.UserDAO;
import com.swiftbyte.dao.impl.UserDAOImpl;

public class Testing {

    public static void main(String[] args) {
    	//check for the update method
        /*Scanner sc = new Scanner(System.in);
        UserDAO dao = new UserDAOImpl();

        System.out.print("Enter User ID: ");
        int userId = sc.nextInt();
        sc.nextLine();

        // Step 1: Fetch current user from DB
        User user = dao.getUser(userId);

        if (user == null) {
            System.out.println("User not found!");
            sc.close();
            return;
        }

        // Step 2: Show current object
        System.out.println("\nCurrent User Details:");
        System.out.println(user);

        // Step 3: Ask for new password
        System.out.print("\nEnter New Password: ");
        String newPassword = sc.nextLine();

        // Step 4: Update object in memory
        user.setPassword(newPassword);

        // Step 5: Save updated object to DB
        dao.updateUser(user);

        // Step 6: Fetch updated object from DB
        User updatedUser = dao.getUser(userId);

        System.out.println("\nUpdated User Details:");
        System.out.println(updatedUser);

        sc.close();
    }*/
    	//check for the delete method
        Scanner sc = new Scanner(System.in);

        UserDAO dao = new UserDAOImpl();

        System.out.print("Enter User ID to Delete: ");
        int userId = sc.nextInt();

        dao.deleteUser(userId);

}
}