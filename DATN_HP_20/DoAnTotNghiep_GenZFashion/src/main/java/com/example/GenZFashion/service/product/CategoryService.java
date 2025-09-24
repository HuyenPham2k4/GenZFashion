package com.example.GenZFashion.service.product;

import com.example.GenZFashion.dto.CategoryDTO;
import com.example.GenZFashion.entity.Category;
import com.example.GenZFashion.repository.thuoctinh.CategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author ASUS
 */
@Service
public class CategoryService {

    private final CategoryRepository categoryRepository;

    @Autowired
    public CategoryService(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    public Page<CategoryDTO> getALLS(Pageable pageable) {
        Page<Category> list = categoryRepository.findAll(pageable);
        return list.map(CategoryDTO::new);
    }

    public Page<CategoryDTO> getAllByStatus(Pageable pageable) {
        Page<Category> list = categoryRepository.findAllByStatus(pageable);
        return list.map(CategoryDTO::new);
    }

    public List<CategoryDTO> getALL() {
        List<Category> list = categoryRepository.findAll();
        return list.stream().map(CategoryDTO::new).toList();
    }

    public Category add(CategoryDTO categoryDTO) {
        return categoryRepository.save(new Category(categoryDTO));
    }

    public Category update(CategoryDTO categoryDTO) {
        return categoryRepository.save(new Category(categoryDTO));
    }

    public void delete(Long id) {
        Category category = categoryRepository.findById(id).get();
        categoryRepository.delete(category);
    }

    public List<CategoryDTO> search(String query) {
        List<Category> list = categoryRepository.findByName(query);
        return list.stream().map(CategoryDTO::new).collect(Collectors.toList());
    }
}
