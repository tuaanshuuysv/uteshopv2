package vn.ute.uteshop.filters;
import jakarta.servlet.*; import java.io.IOException;
/** Placeholder for layout/decorator filter (not actual SiteMesh) */
public class SiteMeshFilter implements Filter {
  @Override public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException { chain.doFilter(req, res); }
}
