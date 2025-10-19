package vn.ute.uteshop.config;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class MailConfig {
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String USERNAME = "tuaanshuuy@gmail.com"; // Email 
    private static final String PASSWORD = "dkgybnyiszwsifxd"; // App password
    private static final String FROM_NAME = "UTESHOP-CPL";

    private static Session getSession() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.ssl.trust", SMTP_HOST);

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USERNAME, PASSWORD);
            }
        });
    }

    public static boolean sendOtpEmail(String toEmail, String otpCode, String type) {
        try {
            Session session = getSession();
            Message message = new MimeMessage(session);

            message.setFrom(new InternetAddress(USERNAME, FROM_NAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));

            String subject = "";
            String body = "";

            switch (type) {
                case "REGISTRATION":
                    subject = "[UTESHOP-CPL] Xác thực tài khoản";
                    body = buildRegistrationEmailBody(otpCode);
                    break;
                case "FORGOT_PASSWORD":
                    subject = "[UTESHOP-CPL] Đặt lại mật khẩu";
                    body = buildForgotPasswordEmailBody(otpCode);
                    break;
                default:
                    return false;
            }

            message.setSubject(subject);
            message.setContent(body, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("✅ Email sent successfully to: " + toEmail);
            return true;

        } catch (Exception e) {
            System.err.println("❌ Failed to send email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private static String buildRegistrationEmailBody(String otpCode) {
        return "<!DOCTYPE html>" +
                "<html><body style='font-family: Arial, sans-serif;'>" +
                "<div style='max-width: 600px; margin: 0 auto; padding: 20px;'>" +
                "<h2 style='color: #007bff;'>Chào mừng bạn đến với UTESHOP-CPL!</h2>" +
                "<p>Cảm ơn bạn đã đăng ký tài khoản. Vui lòng sử dụng mã OTP dưới đây để kích hoạt tài khoản:</p>" +
                "<div style='background: #f8f9fa; padding: 20px; text-align: center; margin: 20px 0;'>" +
                "<span style='font-size: 24px; font-weight: bold; color: #007bff;'>" + otpCode + "</span>" +
                "</div>" +
                "<p><strong>Lưu ý:</strong> Mã OTP có hiệu lực trong 5 phút.</p>" +
                "<p>Nếu bạn không thực hiện đăng ký này, vui lòng bỏ qua email này.</p>" +
                "<hr><p style='color: #6c757d; font-size: 12px;'>© 2025 UTESHOP-CPL by tuaanshuuysv. All rights reserved.</p>" +
                "</div></body></html>";
    }

    private static String buildForgotPasswordEmailBody(String otpCode) {
        return "<!DOCTYPE html>" +
                "<html><body style='font-family: Arial, sans-serif;'>" +
                "<div style='max-width: 600px; margin: 0 auto; padding: 20px;'>" +
                "<h2 style='color: #dc3545;'>Đặt lại mật khẩu UTESHOP-CPL</h2>" +
                "<p>Bạn đã yêu cầu đặt lại mật khẩu. Vui lòng sử dụng mã OTP dưới đây:</p>" +
                "<div style='background: #f8f9fa; padding: 20px; text-align: center; margin: 20px 0;'>" +
                "<span style='font-size: 24px; font-weight: bold; color: #dc3545;'>" + otpCode + "</span>" +
                "</div>" +
                "<p><strong>Lưu ý:</strong> Mã OTP có hiệu lực trong 5 phút.</p>" +
                "<p>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.</p>" +
                "<hr><p style='color: #6c757d; font-size: 12px;'>© 2025 UTESHOP-CPL by tuaanshuuysv. All rights reserved.</p>" +
                "</div></body></html>";
    }
}
