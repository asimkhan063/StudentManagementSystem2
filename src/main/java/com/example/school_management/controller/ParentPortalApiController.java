package com.example.school_management.controller;

import com.example.school_management.dto.LinkParentRequest;
import com.example.school_management.dto.ParentLinkResponse;
import com.example.school_management.dto.ParentStudentResponse;
import com.example.school_management.serviceImpl.ParentPortalService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.security.Principal;
import java.util.List;

@RestController
@RequestMapping("/api")
public class ParentPortalApiController {

    private final ParentPortalService parentPortalService;

    public ParentPortalApiController(ParentPortalService parentPortalService) {
        this.parentPortalService = parentPortalService;
    }

    @PostMapping("/admin/parents/links")
    public ParentLinkResponse linkStudent(@Valid @RequestBody LinkParentRequest request) {
        return parentPortalService.linkStudent(request);
    }

    @GetMapping("/admin/parents/links")
    public List<ParentLinkResponse> getAllLinks() {
        return parentPortalService.getAllLinks();
    }

    @GetMapping("/parent/children")
    public List<ParentStudentResponse> getMyChildren(Principal principal) {
        return parentPortalService.getChildren(principal.getName());
    }
}
