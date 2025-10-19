package vn.ute.uteshop.common;
/** Slug helper (stub) */
public final class SlugUtil { public static String toSlug(String s){ return s==null? null : s.trim().toLowerCase().replaceAll("[^a-z0-9]+","-"); } }
