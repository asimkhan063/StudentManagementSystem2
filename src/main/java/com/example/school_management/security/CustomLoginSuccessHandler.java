package com.example.school_management.security;

import com.example.school_management.entity.AppUser;
import com.example.school_management.repository.AppUserRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {


    @Autowired
    private AppUserRepository appUserRepository;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Authentication authentication)
            throws IOException, ServletException {

        String username = authentication.getName();
        AppUser appUser = appUserRepository.findByUsername(username);
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();

        if (appUser != null) {
            HttpSession session = request.getSession();
            session.setAttribute("roleId", appUser.getRoleId());
            session.setAttribute("role", appUser.getRole());
        }

        String role = authentication.getAuthorities().iterator().next().getAuthority();
        System.out.println("User logged in with role: " + role);

        if (userDetails.isMustChangePassword()) {
            response.sendRedirect("/change-password");
        } else {
            System.out.println("Else case-----------------");
            switch (role) {
                case "ROLE_ADMIN":
                    System.out.println("Admin case Pass-----------------");
                    response.sendRedirect("/admin/dashboard");
                    break;
                case "ROLE_TEACHER":
                    System.out.println("Teacher case Pass-----------------");
                    response.sendRedirect("/teachers/dashboard");
                    break;
                case "ROLE_STUDENT":
                    System.out.println("Student case Pass-----------------");
                    response.sendRedirect("/student/dashboard");
                    break;
                case "ROLE_PARENT":
                    response.sendRedirect("/parent/dashboard");
                    break;
                default:
                    response.sendRedirect("/login");
            }
        }
    }
}
