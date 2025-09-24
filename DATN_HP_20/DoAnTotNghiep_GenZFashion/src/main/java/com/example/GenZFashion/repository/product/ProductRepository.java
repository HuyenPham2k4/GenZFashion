package com.example.GenZFashion.repository.product;

import com.example.GenZFashion.entity.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
//
    @Query(value = "select p.ID, p.Name,p.CategoryID, p.BrandID from Product p where p.ID= :id")
    Product fillAll( @Param("id") Long id);

    @Query(value = "select p from Product p order by p.ID desc")
    List<Product> findAll();

    @Query(value = "select p from Product p order by p.ID desc")
    Page<Product> findAll(Pageable pageable);

    @Query(value = "select p from Product p where p.Name LIKE %:keyword%  or p.BrandID.Name LIKE %:keyword%  or p.BrandID.Note LIKE %:keyword%  or p.CategoryID.Name LIKE %:keyword%  order by p.ID desc")
    Page<Product> resultProduct(Pageable pageable, @Param("keyword") String keywork);

    @Query(value = "select p from Product p where p.CategoryID.ID = :id order by p.ID desc")
    Page<Product> filterByCategory(Pageable pageable, @Param("id") Long id);

    @Query(value = "select p from Product p where p.BrandID.ID = :id order by p.ID desc")
    Page<Product> filterByBrand(Pageable pageable, @Param("id") Long id);


    Product findByID(Long id);
}
