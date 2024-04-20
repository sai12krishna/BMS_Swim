package bms;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/Main")
public class Main extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String action = request.getParameter("action");
        
        if ("validate".equals(action)) {
            // Call the LessonServlet's doPost method for validation
            LessonServlet lessonServlet = new LessonServlet();
            lessonServlet.doPost(request, response);
        } else if ("cancel".equals(action)) {
            // Redirect to the CancelLessonServlet
            response.sendRedirect("CancelLessonServlet");
        } else if ("submit_review".equals(action)) {
            // Show an alert message for submitting review
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<script type=\"text/javascript\">");
            out.println("alert('Thanks for your review!');");
            out.println("location='index.jsp';");
            out.println("</script>");
        }
        else if ("get_booked_lessons".equals(action)) {
            // Retrieve booked lessons and send them to the client
            LessonServlet lessonServlet = new LessonServlet();
            lessonServlet.doGet(request, response);  
        }
    }
}