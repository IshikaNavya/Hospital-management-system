
create database HMS;
USE HMS;

-- Create the Patient Table
CREATE TABLE Patient(
    email VARCHAR(50) PRIMARY KEY,
    password VARCHAR(30) NOT NULL,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(60) NOT NULL,
    gender VARCHAR(20) NOT NULL
);

-- Create the MedicalHistory Table
CREATE TABLE MedicalHistory(
    id INT PRIMARY KEY,
    date DATE NOT NULL,
    conditions VARCHAR(100) NOT NULL, 
    surgeries VARCHAR(100) NOT NULL, 
    medication VARCHAR(100) NOT NULL
);

-- Create the Doctor Table
CREATE TABLE Doctor(
    email VARCHAR(50) PRIMARY KEY,
    gender VARCHAR(20) NOT NULL,
    password VARCHAR(30) NOT NULL,
    name VARCHAR(50) NOT NULL
);

-- Create the Appointment Table
CREATE TABLE Appointment(
    id INT PRIMARY KEY,
    date DATE NOT NULL,
    starttime TIME NOT NULL,
    endtime TIME NOT NULL,
    status VARCHAR(15) NOT NULL
);

-- Create the PatientsAttendAppointments Table
CREATE TABLE PatientsAttendAppointments(
    patient VARCHAR(50) NOT NULL,
    appt INT NOT NULL,
    concerns VARCHAR(40) NOT NULL,
    symptoms VARCHAR(40) NOT NULL,
    FOREIGN KEY (patient) REFERENCES Patient (email) ON DELETE CASCADE,
    FOREIGN KEY (appt) REFERENCES Appointment (id) ON DELETE CASCADE,
    PRIMARY KEY (patient, appt)
);

-- Create the Schedule Table
CREATE TABLE Schedule(
    id INT NOT NULL,
    starttime TIME NOT NULL,
    endtime TIME NOT NULL,
    breaktime TIME NOT NULL,
    day VARCHAR(20) NOT NULL,
    PRIMARY KEY (id, starttime, endtime, breaktime, day)
);

-- Create the PatientsFillHistory Table
CREATE TABLE PatientsFillHistory(
    patient VARCHAR(50) NOT NULL,
    history INT NOT NULL,
    FOREIGN KEY (patient) REFERENCES Patient (email) ON DELETE CASCADE,
    FOREIGN KEY (history) REFERENCES MedicalHistory (id) ON DELETE CASCADE,
    PRIMARY KEY (history)
);

-- Create the Diagnose Table
CREATE TABLE Diagnose(
    appt INT NOT NULL,
    doctor VARCHAR(50) NOT NULL,
    diagnosis VARCHAR(40) NOT NULL,
    prescription VARCHAR(50) NOT NULL,
    FOREIGN KEY (appt) REFERENCES Appointment (id) ON DELETE CASCADE,
    FOREIGN KEY (doctor) REFERENCES Doctor (email) ON DELETE CASCADE,
    PRIMARY KEY (appt, doctor)
);

-- Create the DocsHaveSchedules Table
CREATE TABLE DocsHaveSchedules(
    sched INT NOT NULL,
    doctor VARCHAR(50) NOT NULL,
    FOREIGN KEY (sched) REFERENCES Schedule (id) ON DELETE CASCADE,
    FOREIGN KEY (doctor) REFERENCES Doctor (email) ON DELETE CASCADE,
    PRIMARY KEY (sched, doctor)
);

-- Create the DoctorViewsHistory Table
CREATE TABLE DoctorViewsHistory(
    history INT NOT NULL,
    doctor VARCHAR(50) NOT NULL,
    FOREIGN KEY (doctor) REFERENCES Doctor (email) ON DELETE CASCADE,
    FOREIGN KEY (history) REFERENCES MedicalHistory (id) ON DELETE CASCADE,
    PRIMARY KEY (history, doctor)
);

-- Inserting Values into the Patient Table
INSERT INTO Patient(email, password, name, address, gender)
VALUES
    ('john_doe@gmail.com', 'newpassword123', 'John Doe', 'California', 'male'),
    ('jane_smith@gmail.com', 'password321', 'Jane Smith', 'New York', 'female'),
    ('mike_jones@gmail.com', 'mikepass2025', 'Mike Jones', 'Texas', 'male');

-- Inserting Values into the MedicalHistory Table
INSERT INTO MedicalHistory(id, date, conditions, surgeries, medication)
VALUES
    (1, '2025-01-14', 'High Fever', 'Knee Surgery', 'Paracetamol'),
    (2, '2025-02-10', 'Frequent Headaches', 'None', 'Aspirin'),
    (3, '2025-03-12', 'Back Pain', 'Spinal Surgery', 'Ibuprofen');

-- Inserting Values into the Doctor Table
INSERT INTO Doctor(email, gender, password, name)
VALUES
    ('dr_athalye@gmail.com', 'male', 'doctorpass123', 'Dr. Hrishikesh Athalye'),
    ('dr_morgan@gmail.com', 'female', 'docmorgan2025', 'Dr. Emily Morgan');

-- Inserting Values into the Appointment Table
INSERT INTO Appointment(id, date, starttime, endtime, status)
VALUES
    (1, '2025-04-15', '09:00', '10:00', 'Scheduled'),
    (2, '2025-04-16', '10:00', '11:00', 'Scheduled'),
    (3, '2025-04-17', '14:00', '15:00', 'Scheduled');

-- Inserting Values into the PatientsAttendAppointments Table
INSERT INTO PatientsAttendAppointments(patient, appt, concerns, symptoms)
VALUES
    ('john_doe@gmail.com', 1, 'Coughing', 'Sore Throat'),
    ('jane_smith@gmail.com', 2, 'Dizziness', 'Headache'),
    ('mike_jones@gmail.com', 3, 'Back Pain', 'Stiffness');

-- Inserting Values into the Schedule Table
INSERT INTO Schedule(id, starttime, endtime, breaktime, day)
VALUES
    (1, '09:00', '17:00', '12:00', 'Monday'),
    (2, '09:00', '17:00', '12:00', 'Wednesday'),
    (3, '09:00', '17:00', '12:00', 'Friday');

-- Inserting Values into the PatientsFillHistory Table
INSERT INTO PatientsFillHistory(patient, history)
VALUES
    ('john_doe@gmail.com', 1),
    ('jane_smith@gmail.com', 2),
    ('mike_jones@gmail.com', 3);

-- Inserting Values into the Diagnose Table
INSERT INTO Diagnose(appt, doctor, diagnosis, prescription)
VALUES
    (1, 'dr_athalye@gmail.com', 'Cold', 'Rest and Drink Fluids'),
    (2, 'dr_morgan@gmail.com', 'Migraine', 'Painkillers and Rest'),
    (3, 'dr_morgan@gmail.com', 'Sciatica', 'Physical Therapy');

-- Inserting Values into the DocsHaveSchedules Table
INSERT INTO DocsHaveSchedules(sched, doctor)
VALUES
    (1, 'dr_athalye@gmail.com'),
    (2, 'dr_morgan@gmail.com');

-- Inserting Values into the DoctorViewsHistory Table
INSERT INTO DoctorViewsHistory(history, doctor)
VALUES
    (1, 'dr_athalye@gmail.com'),
    (2, 'dr_morgan@gmail.com'),
    (3, 'dr_morgan@gmail.com');
  
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
