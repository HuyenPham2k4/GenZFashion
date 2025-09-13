package com.example.GenZFashion.service.account.customer;

import com.example.GenZFashion.dto.EmployeeDTO;
import com.example.GenZFashion.entity.Employee;
import com.example.GenZFashion.repository.auth.EmployeeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class EmployeeService {
    @Autowired
    EmployeeRepository employeeRepository;

    public List<EmployeeDTO> findAll() {
        List<Employee> employee = employeeRepository.findAll();
        return employee.stream().map(employee1 ->
                new EmployeeDTO(employee1)).collect(Collectors.toList());
    }

    public EmployeeDTO findByID(Long id) {
        Employee employee = employeeRepository.findById(id).orElse(null);
        return new EmployeeDTO(employee);
    }

    public EmployeeDTO saveEmployee(EmployeeDTO dto) {
        Employee employee = employeeRepository.save(new Employee(dto));
        return new EmployeeDTO(employee);
    }

    public EmployeeDTO updateEmployee(EmployeeDTO dto) {
        Employee employee = employeeRepository.save(new Employee(dto));
        return new EmployeeDTO(employee);
    }

}
