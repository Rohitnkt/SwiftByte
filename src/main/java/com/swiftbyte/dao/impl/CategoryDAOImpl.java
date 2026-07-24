package com.swiftbyte.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.swiftbyte.dao.CategoryDAO;
import com.swiftbyte.model.Category;
import com.swiftbyte.util.DBConnection;

public class CategoryDAOImpl implements CategoryDAO {

    private static final String INSERT_CATEGORY =
            "INSERT INTO categories (category_name, image_url, slug, display_order, is_active) VALUES (?, ?, ?, ?, ?)";

    private static final String GET_CATEGORY_BY_ID =
            "SELECT * FROM categories WHERE category_id = ?";

    private static final String GET_ALL_ACTIVE_CATEGORIES =
            "SELECT * FROM categories WHERE is_active = TRUE ORDER BY display_order ASC, category_name ASC";

    private static final String UPDATE_CATEGORY =
            "UPDATE categories SET category_name=?, image_url=?, slug=?, display_order=?, is_active=? WHERE category_id=?";

    private static final String DELETE_CATEGORY =
            "DELETE FROM categories WHERE category_id = ?";

    private Category mapCategory(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setCategoryId(rs.getInt("category_id"));
        category.setCategoryName(rs.getString("category_name"));
        category.setImageUrl(rs.getString("image_url"));
        category.setSlug(rs.getString("slug"));
        category.setDisplayOrder(rs.getInt("display_order"));
        category.setActive(rs.getBoolean("is_active"));
        category.setCreatedAt(rs.getTimestamp("created_at"));
        return category;
    }

    @Override
    public boolean addCategory(Category category) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(INSERT_CATEGORY)) {

            pstmt.setString(1, category.getCategoryName());
            pstmt.setString(2, category.getImageUrl());
            pstmt.setString(3, category.getSlug());
            pstmt.setInt(4, category.getDisplayOrder());
            pstmt.setBoolean(5, category.isActive());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public Category getCategoryById(int categoryId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_CATEGORY_BY_ID)) {

            pstmt.setInt(1, categoryId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapCategory(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Category> getAllActiveCategories() {
        List<Category> categories = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_ALL_ACTIVE_CATEGORIES);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                categories.add(mapCategory(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return categories;
    }

    @Override
    public boolean updateCategory(Category category) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(UPDATE_CATEGORY)) {

            pstmt.setString(1, category.getCategoryName());
            pstmt.setString(2, category.getImageUrl());
            pstmt.setString(3, category.getSlug());
            pstmt.setInt(4, category.getDisplayOrder());
            pstmt.setBoolean(5, category.isActive());
            pstmt.setInt(6, category.getCategoryId());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean deleteCategory(int categoryId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(DELETE_CATEGORY)) {

            pstmt.setInt(1, categoryId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
