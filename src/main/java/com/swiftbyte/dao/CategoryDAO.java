package com.swiftbyte.dao;

import java.util.List;
import com.swiftbyte.model.Category;

public interface CategoryDAO {

    boolean addCategory(Category category);

    Category getCategoryById(int categoryId);

    List<Category> getAllActiveCategories();

    boolean updateCategory(Category category);

    boolean deleteCategory(int categoryId);
}
