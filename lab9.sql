lab8 test Khulan Ider
CREATE TABLE Hotel(
	hotelNo VARCHAR(30) PRIMARY KEY,
	hotelName VARCHAR(50),
	city VARCHAR(30));
);
INSERT INTO Hotel (hotelNo, hotelName, city)
VALUES ("H01","Mandakh","Erdenet"),
       ("H02","Happy","Darkhan"),
       ("H03","Amgalan","Ulaanbaatar"),
       ("H04","Saihan","Darkhan"),
       ("H05","Bulgan","Ulaanbaatar");
       
CREATE TABLE Room (
	roomNo VARCHAR(20) PRIMARY KEY,
	hotelNo VARCHAR(30),
	bed INT,
	price INT);
INSERT INTO Room (roomNo, hotelNo, bed, price)
VALUES ("R01","H01",4,600),
       ("R02","H01",2,300),
       ("R03","H01",3,450),
       ("R04","H02",1,150),
       ("R05","H02",2,250),
       ("R06","H02",4,450),
       ("R07","H03",2,400),
       ("R08","H03",3,500),
       ("R09","H04",2,220),
       ("R10","H04",1,150),
       ("R11","H04",3,300),
       ("R12","H05",2,450),
       ("R13","H05",5,800);
       
CREATE TABLE Booking (
	hotelNo VARCHAR(30),
	roomNo VARCHAR(30),
	guestNo VARCHAR(20),
	dateFrom DATE,
	dateTo DATE);
INSERT INTO Booking (hotelNo, roomNo, guestNo, dateFrom, dateTo)
VALUES ("H01","R02","G03","2021-11-05","2021-11-08"),
       ("H01","R01","G04","2021-10-15","2021-10-12"),
       ("H02","R06","G05","2021-03-21","2021-03-24"),
       ("H02","R04","G06","2021-11-06","2021-11-17"),
       ("H02","R05","G07","2021-05-11","2021-05-15"),
       ("H02","R06","G08","2021-07-05","2021-07-13"),
       ("H03","R07","G09","2021-11-05","2021-11-18"),
       ("H03","R08","G10","2021-10-29","2021-11-06"),
       ("H04","R09","","",""),
       ("H04","R10","G02","2021-02-14","2021-02-14"),
       ("H04","R11","G05","2021-10-31","2021-11-05"),
       ("H05","R12","G08","2021-10-05","2021-10-08"),
       ("H05","R13","G07","2021-11-02","2021-11-09"),
       ("H03","R07","G01","2021-10-31","2021-11-01"),
       ("H02","R04","G04","2021-10-29","2021-10-31");

CREATE TABLE Guest (
	guestNo VARCHAR(20),
	guestName VARCHAR(30),
	guestAddress VARCHAR(50),
	phonenumber INT);
INSERT INTO Guest (guestNo, guestName, guestAddress, phonenumber)
VALUES ("G01","Maral","Usnii Gudamj",99195884),
       ("G02","Mark","Tokyo Gudamj",88159588),
       ("G03","Bum","Beijing Gudamj",95696325),
       ("G04","Bat","Seoul Gudamj",80255430),
       ("G05","Saraa","Amarsanaa Gudamj",98521520),
       ("G06","Baldan","Zaisan Gudamj",91115225),
       ("G07","Dondog","Olymp Gudamj",89653265),
       ("G08","Sanchir","Dund gol Gudamj",88445511),
       ("G09","Khuslen","Usnii Gudamj",99192884),
       ("G10","Munkh","Seoul Gudamj",85155525);

1. /*Зочид буудлуудын өрөөний дэлгэрэнгүй мэдээллийг гарга. Үүнд хотын нэр,
буудлын нэр, өрөөний дугаар болон үнийн мэдээллийг гаргаж үнээр нь
эрэмбэлнэ үү.*/

SELECT h.city, h.hotelName, r.roomNo, r.price
FROM room r, hotel h
WHERE r.hotelno=h.hotelno
ORDER BY price DESC

2. /*100-с 300-н үнэтэй өрөөнүүдийг буудлын мэдээллийн хамтаар харуулна уу.*/

SELECT r.*, h.*
FROM room r, hotel h
WHERE r.hotelno=h.hotelno
GROUP BY price
HAVING price BETWEEN 100 AND 300

3. /*Хамгийн олон өрөөтэй зочид буудлын мэдээллийг гаргана уу.*/

SELECT *
FROM hotel
WHERE hotelno=( SELECT hotelno
		FROM room
		GROUP BY hotelno
		ORDER BY COUNT(roomno) DESC LIMIT 1)
		
4. /*Зочид буудал тус бүр хэдэн өрөөтэй болон өрөөнүүдийн хамгийн хямд, их,
дундаж үнийн мэдээллийг харуулна уу.*/

SELECT h.hotelno, COUNT(r.roomno) AS bedtoo, MAX(r.price) AS expensive, MIN(r.price) AS cheap, AVG(r.price) AS dundaj
FROM room r, hotel h
WHERE r.hotelno=h.hotelno
GROUP BY hotelno

5. /*Mark гэсэн нэртэй хүний буудалсан буудлын мэдээлэл, өрөөний мэдээллийг
шүүж гаргана уу.*/

SELECT h.*, r.*
FROM  hotel h, room r
WHERE h.hotelno= r.hotelno AND roomno=(SELECT roomno
				       FROM booking 
                                       WHERE guestno=(SELECT guestno
						      FROM guest
						      WHERE guestname="mark"))
						      
6. /*Өнөөдрийн байдлаар зочинтой байгаа өрөөний дугаар, орны тоо, үнэ,
зочны нэр, утасны дугаар болон тухайн өрөө аль хотод байрладаг ямар
нэртэй буудлын өрөө болохыг харуулна уу. NOW() функцийг ашиглана уу.*/

SELECT r.roomNo, r.bed, g.guestName, g.phonenumber, h.hotelName, h.hotelno, h.city
FROM hotel h, room r, guest g, booking b  
WHERE b.hotelNo=h.hotelNo AND r.hotelNo=h.hotelNo AND g.guestNo=b.guestNo AND b.roomNo=r.roomNo AND NOW() BETWEEN dateFrom AND dateTo

7. /*Зочинтой өрөөний захиалга дуусах хугацааг хоногоор харуулна уу.
DATEDIFF() функцийг ашиглана уу.*/

SELECT roomno, DATEDIFF(NOW(), dateTo) AS Deadline
FROM booking
WHERE NOW() BETWEEN NOW() AND dateTo
 
8. /*Хамгийн их зочинтой зочид буудлын өрөөний мэдээллийг харуулна уу.*/

SELECT h.*, r.*, COUNT(g.guestno) AS zochid
FROM room r, booking b, hotel h, guest g
WHERE b.roomno=r.roomno AND b.hotelno=h.hotelno AND r.hotelno=h.hotelno AND g.guestno=b.guestno
GROUP BY g.guestno AND h.hotelno
ORDER BY h.hotelno DESC

9. /*300-с бага үнэтэй өрөө шууд захиалах боломжтой буудлуудын мэдээллийг
гаргана уу.*/

SELECT DISTINCT h.*
FROM hotel h, room r, booking b
WHERE b.hotelNo=h.hotelNo AND r.hotelNo=h.hotelNo AND b.roomNo=r.roomNo AND r.price<300 AND NOW() BETWEEN dateTo AND NOW()

10. /*Хамгийн удаан хугацаагаар буудалсан зочны дугаар, нэр, буудлын дугаар,
буудал байрлах хот, өрөөний дугаар, үнийн мэдээллийг гаргана уу.*/

SELECT g.guestno, g.guestname, h.hotelno, h.city, r.roomno, r.price, DATEDIFF(dateto,datefrom) AS honog
FROM guest g, hotel h, room r, booking b
WHERE r.hotelno=h.hotelno AND r.roomno=b.roomno AND h.hotelno=b.hotelno AND g.guestno=b.guestno
ORDER BY honog DESC
LIMIT 1



