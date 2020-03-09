DROP DATABASE IF EXISTS book_shop;
CREATE DATABASE book_shop;
USE book_shop;

CREATE TABLE countries(
country_id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
name NVARCHAR(50) NOT NULL UNIQUE CHECK(name <> '')
);

INSERT countries
VALUES
(1,'Беларусь'),
(2,'Украина'),
(3,'Канада'),
(4,'США'),
(5,'Англия'),
(6,'Россия_01'),
(7,'Россия_02'),
(8,'Россия_03'),
(9,'Россия_04');
SELECT * FROM  countries;

CREATE TABLE author(
	author_id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	name NVARCHAR(10) NOT NULL CHECK(name <> 0),
	surname NVARCHAR(10) NOT NULL CHECK(surname <> 0),
	country_id INT NOT NULL,
	FOREIGN KEY (country_id) REFERENCES countries (country_id)
);

INSERT author
VALUES
(1,'Алексей', 'Васильев',1),
(2,'Никхил ','Абрахам',2),
(3,'Василий','Несвижский',3),
(4,'Даниэль ','Леук',5),
(5,'Сергей','Есенин',5),
(6,'Фёдор','Михов',6),
(7,'Александр','Пушкин',7),
(8,'Антон ','Чехов',8),
(9,'Лев','Толстой',9);
SELECT * FROM author; 

CREATE TABLE theme(
theme_id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
name NVARCHAR(10) NOT NULL UNIQUE CHECK(name <> '')
);

INSERT theme
VALUES
(1,'Java'),
(2,'C++'),
(3,'C'),
(4,'C#'),
(5,'Python'),
(6,'Роман'),
(7,'Детектив'),
(8,'Повесть'),
(9,'Рассказ');
SELECT * FROM theme;

CREATE TABLE book(
 book_id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
 name NVARCHAR(30) NOT NULL,
 pages INT NOT NULL CHECK(pages > 0),
 price DECIMAL NOT NULL CHECK(pages >= 0),
 publish_date DATE NOT NULL, -- CHECK(publish_date <= NOW()),
 author_id INT NOT NULL,
 theme_id INT NOT NULL,
FOREIGN KEY (author_id) REFERENCES author(author_id),
 FOREIGN KEY (theme_id) REFERENCES theme(theme_id)
);

INSERT book
VALUES
(1,'А, Java на Windows!',500,30,'2004-08-11',1,1),
(2,'Зелёный C++',620,30.5,'1999-08-20',2,2),
(3,'Microsof и C',710,25.7,'1991-06-11',3,3),
(4,'C# и Windows',360,22,'1998-02-19',4,4),
(5,'Программирование на Python',280,11,'2003-03-21',5,5),
(6,'Идиот',550,33,'1869-08-15',6,6),
(7,'Агата и сыск',533,28,'1956-08-25',7,7),
(8,'Чёрный монах',700,25,'1915-08-14',8,8),
(9,'Сырость в тёмном замке',800,33,'1909-05-09',9,9);
SELECT * FROM book;

CREATE TABLE shop(
shop_id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
name NVARCHAR(64) NOT NULL CHECK(name <> ''),
country_id INT NOT NULL,
FOREIGN KEY (country_id) REFERENCES countries (country_id)
);

INSERT shop
VALUES
(1,'Основы Java',1),
(2,'С++',2),
(3,'С',3),
(4,'С#',4),
(5,'Python',5),
(6,'Роман',6),
(7,'Детектив',7),
(8,'Повесть',8),
(9,'Рассказ',9);
SELECT * FROM shop;

CREATE TABLE sale(
sale_id  INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
price DECIMAL NOT NULL,
quantity INT NOT NULL CHECK(quantity > 0),
sale_date DATE NOT NULL,-- DEFAULT NOW() CHECK(sale_date <= NOW()),
book_id INT NOT NULL,
shop_id INT NOT NULL,
FOREIGN KEY (book_id) REFERENCES book(book_id),
FOREIGN KEY (shop_id) REFERENCES shop(shop_id)
);

INSERT sale
VALUES
(1,30,2,'2004-08-11',1,1),
(2,30.5,1,'1999-08-20',2,2),
(3,25.7,5,'1991-06-11',3,3),
(4,22,7,'1998-02-19',4,4),
(5,11,15,'2003-03-21',5,5),
(6,33,5,'1869-08-15',6,6),
(7,28,44,'1956-08-25',7,7),
(8,25,52,'1915-08-14',8,8),
(9,33,1,'1909-05-09',9,9);
SELECT * FROM sale;

-- task01
SELECT * FROM book WHERE (pages >= 500) AND (pages <= 650);


-- task 02
SELECT * FROM book WHERE name LIKE 'А%' AND 'З%';


-- task03
 SELECT * FROM theme, sale
 WHERE theme.name = 'Детектив' AND (quantity >= 2);
 
 
-- task04
SELECT * FROM book WHERE name LIKE '%Windows%' OR '%Microsoft%';


-- task05
SELECT book.name , theme.name , author.name , author.surname , format(COUNT(pages)/price ,2) 
FROM book 
JOIN theme ON theme.theme_id =book.theme_id
JOIN author ON author.author_id =book.author_id
WHERE price > 0.65;


-- task06
SELECT * FROM book WHERE name LIKE '% % % %';


-- task07
  SELECT book.name, theme.name, author.name, author.surname, book.price, sale.quantity, shop.name
  FROM sale
  JOIN shop ON shop.shop_id = sale.shop_id
  JOIN book ON book.book_id = sale.book_id
  JOIN theme ON theme.theme_id = book.theme_id
  JOIN author ON author.author_id = book.author_id
  JOIN countries ON countries.country_id = shop.country_id
    WHERE book.name NOT LIKE 'V%' AND
 theme.name not LIKE 'Роман%' and
 author.name not like  'Михаил%' and 
 book.price >11.33 and book.price<56 and 
 sale.quantity>=4 and
 countries.name NOT LIKE 'Brazil%' 
 and countries.name not like 'Mexico%';
    
    -- sale08
SELECT  'Количество авторов:' ,COUNT(author.name)
FROM author UNION
SELECT 'Количество книг:' ,COUNT(book.name)
FROM book UNION
SELECT 'Средняя цена продажи:' , format(AVG (sale.price) , 2) 
from sale UNION
SELECT 'Среднее количество страниц:' , format(AVG (book.pages) , 2) 
FROM book;
