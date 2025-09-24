/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */
package com.example.GenZFashion.dto;

import com.example.GenZFashion.entity.Brand;
import com.fasterxml.jackson.annotation.JsonProperty;
/**
 *
 * @author Giohuok
 */
public class BrandDTO {
    private Long ID;
    private String Name;
    private String Note;
    private Boolean Status;


    public BrandDTO(Long ID, String name, String note, Boolean status) {
        this.ID = ID;
        Name = name;
        Note = note;
        Status = status;
    }

    public BrandDTO() {
    }

    public BrandDTO(Brand brand) {
        this.ID = brand.getID();
        this.Name = brand.getName();
        this.Note = brand.getNote();
        this.Status = brand.getStatus();
    }

    @JsonProperty("note")
    public String getNote() {
        return Note;
    }

    @JsonProperty("note")
    public void setNote(String note) {
        Note = note;
    }

    // Getters and Setters
    @JsonProperty("id")
    public Long getID() {
        return ID;
    }

    @JsonProperty("id")
    public void setID(Long ID) {
        this.ID = ID;
    }

    @JsonProperty("name")
    public String getName() {
        return Name;
    }

    @JsonProperty("name")
    public void setName(String name) {
        Name = name;
    }

    @JsonProperty("status")
    public Boolean getStatus() {
        return Status;
    }

    @JsonProperty("status")
    public void setStatus(Boolean status) {
        Status = status;
    }
}
