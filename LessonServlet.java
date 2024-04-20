package bms;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONObject;

@WebServlet("/LessonServlet")
public class LessonServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Map<String, Boolean> bookedLessons = new HashMap<>();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Map<String, Boolean> bookedLessons = (Map<String, Boolean>) session.getAttribute("bookedLessons");
        if (bookedLessons == null) {
            bookedLessons = new HashMap<>();
            session.setAttribute("bookedLessons", bookedLessons);
        }
        
        String name = request.getParameter("learner_name");
        String age = request.getParameter("learner_age");
        String grade = request.getParameter("learner_grade");
        String lessonDate = request.getParameter("selected_date");
        String timeSlot = request.getParameter("time_slot");
        
         boolean isValid = validateInputs(age, grade);
        if (!isValid) {
            // Validation failed
            // Handle validation error, show alert message
            response.sendRedirect("index.jsp?error=invalid_input");
            return;
        }

        // Check if the lesson date and time slot are already booked
        if (bookedLessons.containsKey(lessonDate + "_" + timeSlot) && bookedLessons.get(lessonDate + "_" + timeSlot)) {
            // Slot already booked, show alert message
            response.sendRedirect("index.jsp?error=slot_already_booked");
            return;
        }

        // Book the lesson
        bookedLessons.put(lessonDate + "_" + timeSlot, true);

        // Redirect back to the same page with a success message
        response.sendRedirect("index.jsp?success=true");
    
        response.setStatus(HttpServletResponse.SC_OK);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Convert the booked lessons map to JSON
        JSONObject jsonObject = new JSONObject(bookedLessons);
        String json = jsonObject.toString();    	
        // Set the content type and write the JSON response
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json);
    }

    public boolean validateInputs(String age, String grade) {
        try {
            int ageValue = Integer.parseInt(age);
            int gradeValue = Integer.parseInt(grade);
            return ageValue >= 4 && ageValue <= 11 && gradeValue >= 0 && gradeValue <= 5;
        } catch (NumberFormatException e) {
            return false;
        }
    }
}