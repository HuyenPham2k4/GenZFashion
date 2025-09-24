package com.example.GenZFashion.dto;

import com.example.GenZFashion.entity.Category;
import com.fasterxml.jackson.annotation.JsonProperty;
/**
 *
 * @author ASUS
 */
public class CategoryDTO {
    private Long ID;
    private String Name;
    private Boolean Status;

    public CategoryDTO(Category category) {
        this.ID = category.getID();
        this.Name = category.getName();
        this.Status = category.getStatus();
    }

    // Getters and Setters
    @JsonProperty("id")
    public Long getID() {
        return ID;
    }

    public CategoryDTO() {
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
