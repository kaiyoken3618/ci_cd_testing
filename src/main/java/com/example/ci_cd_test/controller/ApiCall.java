package com.example.ci_cd_test.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class ApiCall {

    @GetMapping("/call")
    public String getApiCall() {
        return "Hello World";
    }
}
