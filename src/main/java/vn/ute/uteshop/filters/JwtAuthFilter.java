package vn.ute.uteshop.filters;
import jakarta.servlet.*; import java.io.IOException;
/** Attach auth user from JWT (stub) */
public class JwtAuthFilter implements Filter {
  @Override public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException { chain.doFilter(req, res); }
}
