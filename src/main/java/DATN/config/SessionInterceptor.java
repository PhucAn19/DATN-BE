package DATN.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

@Component
public class SessionInterceptor implements HandlerInterceptor {
    private static final long SESSION_TIMEOUT = 60; // 60 minutes

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        String requestURI = request.getRequestURI();

        // Skip interceptor for public endpoints
        if (requestURI.startsWith("/auth/") || requestURI.equals("/Dangnhap") || requestURI.equals("/DangkyUser")) {
            return true;
        }

        // Redirect logged-in users from login page
        if (session != null && session.getAttribute("user") != null && requestURI.equals("/Dangnhap")) {
            String role = (String) session.getAttribute("role");
            response.sendRedirect(role.equals("ADMIN") ? "/Dashboard" : "/");
            return false;
        }

        // Check if user is not logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("/Dangnhap?notLoggedIn=true");
            return false;
        }

        // Check session expiration
        LocalDateTime sessionStartTime = (LocalDateTime) session.getAttribute("sessionStartTime");
        if (sessionStartTime != null && ChronoUnit.MINUTES.between(sessionStartTime, LocalDateTime.now()) >= SESSION_TIMEOUT) {
            session.invalidate();
            response.sendRedirect("/login?sessionExpired=true");
            return false;
        }

        return true;
    }
}