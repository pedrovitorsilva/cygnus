CREATE DATABASE IF NOT EXISTS cygnus;

USE cygnus;

DROP TABLE IF EXISTS products;

CREATE TABLE products (
    id int NOT NULL AUTO_INCREMENT,
    companyName varchar(10) NOT NULL,
    companyAvatar varchar(50) NOT NULL,
    name varchar(100) NOT NULL,
    description varchar(255) NOT NULL,
    price float NOT NULL,
    PRIMARY KEY(id)
);

INSERT INTO products VALUES 
(1,"Bethesda","bethesda.jpeg","Fallout 4","Experience the next generation of open-world gaming in this epic post-apocalyptic adventure.",129.99),
(2,"Ubisoft", "ubisoft.jpeg","Assassin's Creed Odyssey","Explore ancient Greece as a legendary Spartan hero in this epic adventure.",99.99),
(3,"Microsoft", "microsoft.jpeg","Halo 5","Master Chief returns in the next chapter of the legendary Halo series.", 59.99),
(4,"Bethesda","bethesda.jpeg","The Elder Scrolls V: Skyrim","Embark on an epic journey to save Tamriel from dragons in this open-world RPG.",39.99),
(5,"Ubisoft", "ubisoft.jpeg","Far Cry 6","Lead a guerrilla revolution against a brutal dictator in a tropical paradise.", 69.99),
(6,"Microsoft", "microsoft.jpeg","Forza Horizon 5", "Experience the thrill of the Horizon Festival in beautiful Mexico.", 69.99),
(7,"Bethesda","bethesda.jpeg","DOOM Eternal","Rip and tear through demons in this fast-paced first-person shooter.",49.99),
(8,"Ubisoft", "ubisoft.jpeg","Watch Dogs: Legion","Build a resistance and fight back against an authoritarian regime in near-future London.",59.99),
(9,"Microsoft", "microsoft.jpeg", "Gears 5","Join Kait Diaz on her journey to uncover her connection to the enemy and the true danger to Sera.",59.99),
(10,"Bethesda","bethesda.jpeg","The Elder Scrolls Online", "Explore the world of Tamriel with friends in this massively multiplayer online RPG.",29.99);

DROP TABLE IF EXISTS rating;

CREATE TABLE rating (
    id int NOT NULL AUTO_INCREMENT,
    product_id int NOT NULL,
    rating float NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO rating VALUES
(1,1,5.0),
(2,2,2.5),
(3,3,4.5),
(4,4,4.7),
(5,5,3.7),
(6,6,4.9),
(7,7,4.6),
(8,8,2.4),
(9,9,4.7),
(10,10,4.8);

DROP TABLE IF EXISTS reviews;

CREATE table reviews (
    id int NOT NULL AUTO_INCREMENT,
    product_id int NOT NULL,
    user_id int,
    user_name varchar(255) NOT NULL,
    user_email varchar(255),
    user_rating float NOT NULL,
    user_comment varchar(255) NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO reviews VALUES 
(1,1,1,"Davy Jones", "Gameplayrj@gmail.com",5,"Adorei, maluco"),
(2,1,2,"Cross", "Cross@yahoo.com",5,"Adorei zerar"),
(3,2,1,"Davy Jones", "Gameplayrj@gmail.com",2,"Gostei não, mané"),
(4,2,2,"Cross", "Cross@yahoo.com",3,"Mediano demais"),
(5,3,1,"Davy Jones", "Gameplayrj@gmail.com",5,"Adorei, maluco"),
(6,3,2,"Cross", "Cross@yahoo.com",4,"Muito bom"),
(7,4,1,"Davy Jones", "Gameplayrj@gmail.com",4.8,"Adorei, maluco"),
(8,4,2,"Cross", "Cross@yahoo.com",4.6,"Top"),
(9,5,1,"Davy Jones", "Gameplayrj@gmail.com",3.5,"Gostei não, mané"),
(10,5,2,"Cross", "Cross@yahoo.com",3.9,"Mediano demais"),
(11,6,1,"Davy Jones", "Gameplayrj@gmail.com",5,"Adorei, maluco"),
(12,6,2,"Cross", "Cross@yahoo.com",4.8,"Adorei dms"),
(13,7,1,"Davy Jones", "Gameplayrj@gmail.com",5,"Bom demais"),
(14,7,2,"Cross", "Cross@yahoo.com",4.2,"Até que é bom"),
(15,8,1,"Davy Jones", "Gameplayrj@gmail.com",2,"Gostei não, mané"),
(16,8,2,"Cross", "Cross@yahoo.com",2.8,"Mediano demais"),
(17,9,1,"Davy Jones", "Gameplayrj@gmail.com",4.7,"INCRIVEEELLLL"),
(18,9,2,"Cross", "Cross@yahoo.com",4.7,"Não esperava que fosse tão bom"),
(19,10,1,"Davy Jones", "Gameplayrj@gmail.com",4.7,"Gostei bastante"),
(20,10,2,"Cross", "Cross@yahoo.com",4.9,"É bom demais");