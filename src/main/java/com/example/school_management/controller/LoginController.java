package com.example.school_management.controller;

import com.example.school_management.entity.AppUser;
import com.example.school_management.repository.AppUserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;

@Controller
public class LoginController {

    private final AppUserRepository appUserRepository;
    private final PasswordEncoder passwordEncoder;

    public LoginController(AppUserRepository appUserRepository, PasswordEncoder passwordEncoder) {
        this.appUserRepository = appUserRepository;
        this.passwordEncoder = passwordEncoder;
    }


    @GetMapping("/login")
    public String showLoginPage() {
        System.out.println("Login Page calling.....");
        return "login/login"; // JSP name (without .jsp extension)
    }

    @GetMapping("/change-password")
    public String ShowChangePage() {
        System.out.println("Login Page calling.....");
        return "login/change-password"; // JSP name (without .jsp extension)
    }

    @PostMapping("/change-password")
    public String handleChangePassword(@RequestParam String newPassword,
                                       Principal principal,
                                       RedirectAttributes redirectAttributes) {
        String username = principal.getName();
        AppUser user = appUserRepository.findByUsername(username);

        if (user != null) {
            // update password (make sure to encode it)
            user.setPassword(passwordEncoder.encode(newPassword));
            user.setMustChangePassword(false); // or however you're managing that flag
            appUserRepository.save(user);

            redirectAttributes.addFlashAttribute("success", "Password changed successfully!");
            // return "redirect:/dashboard"; // or appropriate page

            switch (user.getRole()) {
                case "ADMIN":
                    return "redirect:/admin/dashboard";
                case "TEACHER":
                    return "redirect:/teachers/dashboard";
                case "STUDENT":
                    return "redirect:/student/dashboard";
                case "PARENT":
                    return "redirect:/parent/dashboard";
                default:
                    return "redirect:/login";
            }

        }

        redirectAttributes.addFlashAttribute("error", "User not found.");
        return "redirect:/change-password";
    }

}
