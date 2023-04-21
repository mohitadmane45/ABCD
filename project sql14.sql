Create database hospital;

use hospital;

#1.write a SQL query to identify the physicians who are the department heads.
# Return Department name as “Department” and Physician name as “Physician”.


select * from physician;
select * from department;
select 
d.name as 'department',
p.name as 'physician'
from department as d inner join physician as p
on d.head=p.employeeid;


select 
d.name as 'department',
p.name as 'physician'
from department as d,physician as p
where d.head=p.employeeid;

#2. write a SQL query to locate the floor and block where room number 212 is located. 
#Return block floor as "Floor" and block code as "Block".
select blockfloor as 'floor',
blockcode as 'block'
from room
where roomnumber=212;

#3. write a SQL query to count the number of unavailable rooms. Return count as "Number of unavailable rooms".
select count(*) as 'number of unavailable rooms'
from room 
where unavailable='t';

#4. write a SQL query to identify the physician and the department with which he or she is affiliated. 
#Return Physician name as "Physician", and department name as "Department". 
SELECT p.name AS "Physician",
       d.name AS "Department"
FROM physician p,
     department d,
     affiliated_with a
WHERE p.employeeid=a.physician
  AND a.department=d.departmentid;
  
  
  #5. write a SQL query to find those physicians who have received special training.
# Return Physician name as “Physician”, treatment procedure name as "Treatment"
select p.name as 'physician',
c.name as 'treatment'
from physician as p,
procedures as c,
  trained_in as t 
  where t.physician=p.employeeid 
  and t.treatment=c.code;
  
  #6. write a SQL query to find those physicians who are yet to be affiliated.
# Return Physician name as "Physician", Position, and department as "Department". 
SELECT p.name AS "Physician",
       p.position,
       d.name AS "Department"
FROM physician p
INNER JOIN affiliated_with a ON a.physician=p.employeeid
INNER JOIN department d ON a.department=d.departmentid
WHERE primaryaffiliation='f';

#7. write a SQL query to identify physicians who are not specialists. Return Physician name as "Physician", position as "Designation".
select p.name as 'physician',
p.position 'designation'
from physician p 
left join trained_in t on p.employeeid=t.physician
where t.treatment is null
order by employeeid;

#8. write a SQL query to identify the patients and the number of physicians with whom they have scheduled appointments. 
#Return Patient name as "Patient", number of Physicians as "Appointment for No. of Physicians".

SELECT p.name "Patient",
       count(t.patient) "Appointment for No. of Physicians"
FROM appointment t
JOIN patient p ON t.patient=p.ssn
GROUP BY p.name
HAVING count(t.patient)>=1;

#9. write a SQL query to count the number of unique patients who have been scheduled for examination room 'C'.
# Return unique patients as "No. of patients got appointment for room C". 
select count(distinct patient) as 'no.of patients got appoinment for room c'
from appointment
where examinationroom='c';


#10. write a SQL query to identify the nurses and the room in which they will assist the physicians. 
#Return Nurse Name as "Name of the Nurse" and examination room as "Room No.". 
SELECT n.name AS "Name of the Nurse",
       a.examinationroom AS "Room No."
FROM nurse n
JOIN appointment a ON a.prepnurse=n.employeeid;

#11. write a SQL query to locate the patients' treating physicians and medications. 
#Return Patient name as "Patient", Physician name as "Physician", Medication name as "Medication". 

select t.name as 'patient',
p.name as 'physician',
m.name as 'medication'
from patient t  
join prescribes s on s.patient=t.ssn
join physician p on s.physician=p.employeeid
join medication m on s.medication=m.code;

  
#12. write a SQL query to count the number of available rooms in each block. Sort the result-set on ID of the block. 
#Return ID of the block as "Block", count number of available rooms as "Number of available rooms".

SELECT blockcode AS "Block",
       count(*) "Number of available rooms"
FROM room
WHERE unavailable='f'
GROUP BY blockcode
ORDER BY blockcode;

#13. write a SQL query to count the number of available rooms for each floor in each block. Sort the result-set on floor ID, ID of the block. 
#Return the floor ID as "Floor", ID of the block as "Block", and number of available rooms as "Number of available rooms".
  	select blockfloor as 'floor',
    blockcode as 'block',
    count(*) as 'number as available rooms'
    from room 
    where unavailable='f'
    group by blockfloor,
    blockcode
    order by blockfloor,
    blockcode;
    
    
#14. write a SQL query to find the name of the patients, their block, floor, and room number where they admitted.
select p.name as 'patient',
s.room as 'room',
r.blockfloor as 'floor',
r.blockcode as 'block'
from stay s
join patient p on s.patient=p.ssn
join room r on s.room=r.roomnumber;


#15. write a SQL query to find all physicians who have performed a medical procedure but are not certified to do so.
# Return Physician name as "Physician".
SELECT name AS "Physician"
FROM physician
WHERE employeeid IN
    ( SELECT undergoes.physician
     FROM undergoes
     LEFT JOIN trained_In ON undergoes.physician=trained_in.physician
     AND undergoes.procedure=trained_in.treatment
     WHERE treatment IS NULL );


#16. write a SQL query to determine which patients have been prescribed medication by their primary care physician.
# Return Patient name as "Patient", and Physician Name as "Physician".
SELECT pt.name AS "Patient",
       p.name AS "Physician"
FROM patient pt
JOIN prescribes pr ON pr.patient=pt.ssn
JOIN physician p ON pt.pcp=p.employeeid
WHERE pt.pcp=pr.physician
  AND pt.pcp=p.employeeid;
  
#17.write a SQL query to find those patients who have undergone a procedure costing more than $5,000, as well as the name of the physician who has provided primary care, should be identified. 
#Return name of the patient as "Patient", name of the physician as "Primary Physician", and cost for the procedure as "Procedure Cost".
SELECT pt.name AS " Patient ",
p.name AS "Primary Physician",
pd.cost AS " Procedure Cost"
FROM patient pt
JOIN undergoes u ON u.patient=pt.ssn
JOIN physician p ON pt.pcp=p.employeeid
JOIN procedures pd ON u.procedure=pd.code
WHERE pd.cost>5000;


#18. write a SQL query to identify those patients whose primary care is provided by a physician who is not the head of any department. 
# Return Patient name as "Patient", Physician Name as "Primary care Physician".

select pt.name as 'patient',
p.name as 'primart care physician'
from patient pt 
join physician p on pt.pcp=p.employeeid
where pt.pcp not in 
(select head from department);
















