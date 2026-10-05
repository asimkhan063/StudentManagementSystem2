package com.example.school_management.serviceImpl;

import com.example.school_management.entity.AppUser;
import com.example.school_management.repository.AppUserRepository;
import com.example.school_management.security.CustomUserDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

import java.util.Collections;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private AppUserRepository userRepository;


//    @Override
//    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
//        LogUser user = userRepository.findByUsername(username)
//                .orElseThrow(() -> new UsernameNotFoundException("User not found with username: " + username));
//
//          return new CustomUserDetails(user);
////        return new org.springframework.security.core.userdetails.User(
////                user.getUsername(), user.getPassword(), getAuthorities(user.getRoles()));
//    }
//
    ////    private Set<GrantedAuthority> getAuthorities(Set<Role> roles) {
    ////        return roles.stream()
    ////                .map(role -> new SimpleGrantedAuthority("ROLE_" + role.getName()))
    ////                .collect(Collectors.toSet());
    ////    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        AppUser user = userRepository.findByUsername(username);
        if (user == null) throw new UsernameNotFoundException("User not found");

//        return new org.springframework.security.core.userdetails.User(
//                user.getUsername(),
//                user.getPassword(),
//                Collections.singleton(new SimpleGrantedAuthority("ROLE_" + user.getRole()))
//        );

        return new CustomUserDetails(user);
    }
}
