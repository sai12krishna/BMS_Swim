package bms;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import static org.junit.Assert.assertEquals;


public class LessonServletJUnitTest {
    private LessonServlet servlet;
    
    

    @Before
    public void setUp() {
        servlet = new LessonServlet();
        
    }

    @Test
    public void testValidateInputsValid() {
        // Test valid inputs
        assertTrue(servlet.validateInputs("8", "3"));
    }

    @Test
    public void testValidateInputsInvalidAge() {
        // Test invalid age
        assertFalse(servlet.validateInputs("2", "3"));
    }

    @Test
    public void testValidateInputsInvalidGrade() {
        // Test invalid grade
        assertFalse(servlet.validateInputs("8", "6"));
    }

    @Test
    public void testValidateInputsInvalidFormat() {
        // Test invalid format
        assertFalse(servlet.validateInputs("eight", "three"));
    }
   

   
}
