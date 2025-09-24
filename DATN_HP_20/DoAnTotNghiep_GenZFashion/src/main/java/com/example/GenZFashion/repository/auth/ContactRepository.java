package com.example.GenZFashion.repository.auth;

import com.example.GenZFashion.entity.Contact;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface ContactRepository extends JpaRepository<Contact, Integer> {

    @Query("SELECT c FROM Contact c order by c.Id desc")
    List<Contact> findAll();
}
