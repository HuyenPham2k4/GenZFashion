package com.example.GenZFashion.repository.auth.NewsAndIntro;

import com.example.GenZFashion.entity.News;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface NewsRepository extends JpaRepository<News, Integer> {
}
