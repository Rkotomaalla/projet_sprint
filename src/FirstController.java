package com.itu.prom16.controller;
import com.itu.prom16.annotation.*;
@AnnotationController(value="FirstController")
public class FirstController {
    public void execute(){
        System.out.println("Executer");
    }
}
