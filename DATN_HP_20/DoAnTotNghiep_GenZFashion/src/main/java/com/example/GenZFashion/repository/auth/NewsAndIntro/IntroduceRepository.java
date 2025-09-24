package com.example.GenZFashion.repository.auth.NewsAndIntro;

import com.example.GenZFashion.entity.introduce;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface IntroduceRepository extends JpaRepository<introduce, Integer> {
}
