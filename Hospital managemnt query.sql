SELECT doctor, COUNT(appt) AS appointment_count FROM Diagnose GROUP BY doctor;
SELECT doctor, COUNT(DISTINCT appt) AS patient_count FROM Diagnose GROUP BY doctor;
-- Count number of appointments per doctor
SELECT doctor, COUNT(appt) AS appointment_count 
FROM Diagnose 
GROUP BY doctor;

-- Number of patients treated by each doctor
SELECT doctor, COUNT(DISTINCT appt) AS patient_count 
FROM Diagnose 
GROUP BY doctor;

-- Average appointment duration (in minutes)
SELECT AVG(TIMESTAMPDIFF(MINUTE, starttime, endtime)) AS avg_duration 
FROM Appointment;

-- All appointments for a specific patient
SELECT p.name, a.date, a.starttime, a.endtime 
FROM Patient p 
JOIN PatientsAttendAppointments paa ON p.email = paa.patient 
JOIN Appointment a ON paa.appt = a.id 
WHERE p.email = 'alice_smith@gmail.com';

-- All schedules for a specific doctor
SELECT d.name, s.day, s.starttime, s.endtime 
FROM Doctor d 
JOIN DocsHaveSchedules dhs ON d.email = dhs.doctor 
JOIN Schedule s ON dhs.sched = s.id 
WHERE d.email = 'dr_morgan@gmail.com';

-- Patients and their diagnosed conditions
SELECT p.name, diag.diagnosis 
FROM Patient p 
JOIN PatientsAttendAppointments paa ON p.email = paa.patient 
JOIN Diagnose diag ON paa.appt = diag.appt;

-- Insert a new doctor
INSERT INTO Doctor(email, gender, password, name) 
VALUES ('dr_ram@gmail.com', 'male', 'ramdoc2025', 'Dr. Ram Sharma');

-- Update appointment status
UPDATE Appointment 
SET status = 'Completed' 
WHERE id = 2;

-- Doctor diagnosis summary
SELECT a.date, d.name AS doctor_name, diag.diagnosis, diag.prescription 
FROM Appointment a 
JOIN Diagnose diag ON a.id = diag.appt 
JOIN Doctor d ON diag.doctor = d.email;

-- Doctors who viewed history ID 1
SELECT d.name 
FROM Doctor d 
JOIN DoctorViewsHistory dvh ON d.email = dvh.doctor 
WHERE dvh.history = 1;

-- Patients diagnosed with 'Cold'
SELECT p.name 
FROM Patient p 
JOIN PatientsAttendAppointments paa ON p.email = paa.patient 
JOIN Diagnose diag ON paa.appt = diag.appt 
WHERE diag.diagnosis = 'Cold';

-- Doctor schedules for Friday
SELECT d.name, s.starttime, s.endtime 
FROM Doctor d 
JOIN DocsHaveSchedules dhs ON d.email = dhs.doctor 
JOIN Schedule s ON dhs.sched = s.id 
WHERE s.day = 'Friday';

-- Gender-wise patient count
SELECT gender, COUNT(*) AS total 
FROM Patient 
GROUP BY gender;

-- Doctors who have never diagnosed anyone
SELECT name 
FROM Doctor 
WHERE email NOT IN (
    SELECT DISTINCT doctor FROM Diagnose
);

-- Patients with more than 1 appointment
SELECT patient, COUNT(*) AS total_appointments 
FROM PatientsAttendAppointments 
GROUP BY patient 
HAVING COUNT(*) > 1;

-- List all diagnoses made on '2025-04-15'
SELECT d.name AS doctor, diag.diagnosis, a.date 
FROM Diagnose diag 
JOIN Doctor d ON diag.doctor = d.email 
JOIN Appointment a ON diag.appt = a.id 
WHERE a.date = '2025-04-15';