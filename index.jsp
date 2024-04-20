<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swimming School Management System</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Flatpickr CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
</head>
<body>
    <div class="container">
        <h1 class="text-primary">Swimming School Management System</h1>
        
        <!-- Book a Lesson -->
        <div class="mt-4">
            <h2 class="text-primary">Book a Lesson</h2>
            <form id="bookLessonForm" action="Main" method="post">
                <div class="form-group">
                    <label for="learner_name">Your Name:</label>
                    <input type="text" id="learner_name" name="learner_name" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="learner_age">Your Age:</label>
                    <input type="text" id="learner_age" name="learner_age" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="learner_grade">Your Grade:</label>
                    <input type="text" id="learner_grade" name="learner_grade" class="form-control" required>
                </div>
                <button type="button" id="validateBtn" class="btn btn-primary">Validate</button>
                <button type="button" id="bookLessonBtn" class="btn btn-primary disabled" disabled>Book Lesson</button>
            </form>
            <!-- Hidden input field to store selected date -->
            <input type="hidden" id="selectedDate" name="selected_date">
            <!-- Calendar -->
            <div id="calendar" style="display: none;"></div>
            <!-- Time slot dropdown -->
            <select id="timeSlot" name="time_slot" class="form-control" style="display: none;"></select>
        </div>
        <!-- Confirm Booking -->
        <div class="mt-4">
            <button type="button" id="confirmBookingBtn" class="btn btn-success " >Confirm Booking</button>
        </div>

        <!-- Booked Lessons Display -->
        <div class="mt-4">
            <h2 class="text-primary">Booked Lessons</h2>
            <div id="bookedLessonsDisplay"></div>
        </div>

        <!-- Cancel a Lesson -->
        <div class="mt-4">
            <h2 class="text-primary">Cancel a Lesson</h2>
            <form id="cancelLessonForm" action="CancelLessonServlet" method="post">
                <div id="bookedLessons"></div>
                <button type="submit" id="cancelLessonBtn" class="btn btn-danger disabled" disabled>Cancel Lesson</button>
            </form>
        </div>

        <!-- Write a Review -->
        <div class="mt-4">
            <h2 class="text-primary">Write a Review</h2>
            <form action="Main" method="post">
                <div class="form-group">
                    <label for="review_lesson_day">Lesson Day:</label>
                    <select id="review_lesson_day" name="review_lesson_day" class="form-control">
                        <option value="MONDAY">Monday</option>
                        <option value="WEDNESDAY">Wednesday</option>
                        <option value="FRIDAY">Friday</option>
                        <option value="SATURDAY">Saturday</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="Review">Review:</label>
                    <textarea id="Review" name="Review" rows="4" cols="50" class="form-control" required></textarea>
                </div>
                <button type="submit" id="review" class="btn btn-primary">Submit Review</button>
            </form>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <!-- Flatpickr JS -->
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Book Lesson Form Validation
            document.getElementById('validateBtn').addEventListener('click', function() {
                var age = parseInt(document.getElementById('learner_age').value);
                var grade = parseInt(document.getElementById('learner_grade').value);
                if (isNaN(age) || isNaN(grade) || age < 4 || age > 11 || grade < 0 || grade > 5) {
                    alert('Age or grade is invalid');
                } else {
                    document.getElementById('bookLessonBtn').classList.remove('disabled');
                    document.getElementById('bookLessonBtn').disabled = false;
                }
            });

            // Book Class Button - Open Calendar
            document.getElementById('bookLessonBtn').addEventListener('click', function() {
                flatpickr("#calendar", {
                    enableTime: false,
                    dateFormat: "Y-m-d",
                    minDate: "today",
                    onChange: function(selectedDates, dateStr, instance) {
                        document.getElementById('selectedDate').value = dateStr;
                        document.getElementById('calendar').style.display = 'none';
                        populateTimeSlots(dateStr);
                    }
                }).open();
            });

            // Confirm Booking Button
            document.getElementById('confirmBookingBtn').addEventListener('click', function() {
                // Check if a time slot is selected
                var selectedTimeSlot = document.getElementById('timeSlot').value;
                if (selectedTimeSlot) {
                    // Display the booked lesson
                    var selectedDate = document.getElementById('selectedDate').value;
                    var bookedLesson = selectedDate + ' - ' + selectedTimeSlot;
                    var bookedLessonsDisplay = document.getElementById('bookedLessonsDisplay');
                    var lessonDiv = document.createElement('div');
                    lessonDiv.textContent = bookedLesson;
                    bookedLessonsDisplay.appendChild(lessonDiv);

                    // Enable cancel button
                    document.getElementById('cancelLessonBtn').classList.remove('disabled');
                    document.getElementById('cancelLessonBtn').disabled = false;

                    // Reset selected date and time slot
                    document.getElementById('selectedDate').value = '';
                    document.getElementById('timeSlot').selectedIndex = 0;

                    alert('Booking confirmed!');
                } else {
                    // If no time slot is selected, show an alert
                    alert('Please select a time slot before confirming booking.');
                }
            });

            // Function to display booked lessons
            function displayBookedLessons(bookedLessons) {
                var bookedLessonsDisplay = document.getElementById('bookedLessonsDisplay');
                bookedLessonsDisplay.innerHTML = ''; // Clear previous content
                for (var lesson in bookedLessons) {
                    if (bookedLessons[lesson]) {
                        var lessonDiv = document.createElement('div');
                        lessonDiv.textContent = lesson;
                        bookedLessonsDisplay.appendChild(lessonDiv);
                    }
                }
            }

            // Cancel Lesson Form Dynamic Generation
            fetch('LessonServlet')
                .then(response => response.json())
                .then(bookedLessons => {
                    var bookedLessonsDiv = document.getElementById('bookedLessons');
                    for (var lesson in bookedLessons) {
                        var label = document.createElement('label');
                        var checkbox = document.createElement('input');
                        checkbox.type = 'checkbox';
                        checkbox.name = 'lessonToCancel';
                        checkbox.value = lesson;
                        label.appendChild(checkbox);
                        label.appendChild(document.createTextNode(' ' + lesson));
                        label.appendChild(document.createElement('br'));
                        bookedLessonsDiv.appendChild(label);
                    }

                    // Enable cancel button if at least one lesson is booked
                    var cancelLessonBtn = document.getElementById('cancelLessonBtn');
                    if (Object.keys(bookedLessons).length > 0) {
                        cancelLessonBtn.classList.remove('disabled');
                        cancelLessonBtn.disabled = false;
                    }
                })
                .catch(error => console.error('Error fetching booked lessons:', error));

            // Function to populate time slots
            function populateTimeSlots(dateStr) {
                var day = new Date(dateStr).getDay();
                var timeSlotSelect = document.getElementById('timeSlot');
                timeSlotSelect.innerHTML = '';
                var timeSlots = [];
                if (day === 1 || day === 3 || day === 5) { // Monday, Wednesday, Friday
                    timeSlots = ['4-5pm', '5-6pm', '6-7pm'];
                } else if (day === 6) { // Saturday
                    timeSlots = ['2-3pm', '3-4pm'];
                } else {
                    alert('No time slots available for this date');
                }
                timeSlots.forEach(function(slot) {
                    var option = document.createElement('option');
                    option.text = slot;
                    option.value = slot;
                    timeSlotSelect.add(option);
                });
                timeSlotSelect.style.display = 'block';
            }
        });
        
        document.getElementById('review').addEventListener('click', function() {
        	alert('Thanks for the Review');
        });
    </script>
</body>
</html>
