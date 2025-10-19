package vn.ute.uteshop.filters;
import jakarta.servlet.*; import java.io.IOException;
/** Basic role check (stub) */
public class RoleFilter implements Filter {
  @Override public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException { chain.doFilter(req, res); }
}
