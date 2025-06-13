package com.example.demo.Controller;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/hello")
public class HelloController {

    // GET: /api/hello
    @GetMapping
    public String getHello() {
        return "Hello from GET!";
    }

    // POST: /api/hello
    @PostMapping
    public String postHello(@RequestBody String name) {
        return "Hello, " + name + "!";
    }
}
