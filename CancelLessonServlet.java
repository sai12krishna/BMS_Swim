package bms;

import java.io.IOException;
import java.util.Map;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/CancelLessonServlet")
public class CancelLessonServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Map<String, Boolean> bookedLessons = (Map<String, Boolean>) session.getAttribute("bookedLessons");
        if (bookedLessons == null) {
            // No lessons booked, redirect to index.jsp
            response.sendRedirect("index.jsp");
            return;
        }

        String[] lessonsToCancel = request.getParameterValues("lessonToCancel");
        if (lessonsToCancel != null) {
            for (String lesson : lessonsToCancel) {
                // Cancel the selected lessons
                bookedLessons.put(lesson, false);
            }
        }

        // Redirect back to the same page after cancellation
        response.sendRedirect("index.jsp?action=get_booked_lessons");
    }
}