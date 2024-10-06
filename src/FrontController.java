package com.itu.prom16;
import com.itu.prom16.annotation.*;
import com.itu.prom16.controller.*; 
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

import jakarta.servlet.ServletConfig;
import java.lang.reflect.Modifier;
import java.net.URI;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import java.util.Set;
import java.util.stream.Stream;

public class FrontController extends HttpServlet {
    public String packageName;
    private Set<Class<?>> controllersScannes = new HashSet<>();
    private boolean dejaScanne = false;
    public List<String> controllerNames=new ArrayList<>(); 
    
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        this.packageName=config.getInitParameter("controller-package");
    }


    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        String url = request.getRequestURI().toString();
        out.println(packageName);
          if (!dejaScanne) {
            this.ScanController(packageName, out);
        }
        out.println("<html><head>");
        out.println("<title>Servlet FrontController</title>");
        out.println("</head><body>");
        out.println("<p>" + url + "</p>");
        if (controllerNames.isEmpty()) {
            out.println("tsy misy controller ao @ " + packageName);
        } else {
            out.println("les controller trouves:");
            for (String controller : controllerNames) {
                out.println(controller);
            }
        }
        out.println("</body></html>");
        out.close();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    public void ScanController(String packageName,PrintWriter out){
        try {
            ClassLoader classLoader =Thread.currentThread().getContextClassLoader();
            String path=packageName.replace(".","/");
            URL resource=classLoader.getResource(path);
            URI resourceURI=resource.toURI();
            Path classPath=Paths.get(resourceURI);
            
            try(Stream<Path> paths=Files.walk(classPath)){
                paths.filter(f->f.toString().endsWith(".class"))
                    .forEach(f->{
                        String className = packageName + "." + f.getFileName().toString().replace(".class", "");
                        try {
                            Class<?> clazz =Class.forName(className);
                            if(clazz.isAnnotationPresent(AnnotationController.class) && !Modifier.isAbstract(clazz.getModifiers())){
                            controllerNames.add(clazz.getSimpleName());
                            }
                        } catch (ClassNotFoundException e) {
                            e.printStackTrace(out);
                        }
                    });
            }
            this.dejaScanne=false;
        }catch(Exception e){
            e.printStackTrace(out);
        }
    }
}