-- Active: 1729636694938@@127.0.0.1@5432@Cecilia_Reynoso_123
CREATE DATABASE "Cecilia_Reynoso_123";
-- 1.Revisa el tipo de relación y crea el modelo correspondiente. Respeta las claves
--   primarias, foráneas y tipos de datos.
-- Creacion de tabla peliculas
CREATE TABLE peliculas(
  id INT primary key,
  nombre varchar(255),  
  annio INT
  );
-- Creacion de tabla tags
CREATE TABLE tags(
  id INT primary key,
  tag varchar(32)
  );
-- Creacion de tabla pelicula_tag
CREATE TABLE pelicula_tag(
  pelicula_id INT,
  tag_id INT,
  FOREIGN KEY (pelicula_id) REFERENCES peliculas (id),
  FOREIGN KEY (tag_id) REFERENCES tags (id)
);
-- 2. Inserta 5 películas y 5 tags; la primera película debe tener 3 tags asociados, la
--segunda película debe tener 2 tags asociados.
-- Ingreso de valores para cinco peliculas
INSERT INTO
       peliculas (id, nombre, annio)
VALUES
      (1, 'Primera película', 1997),
      (2, 'Segunda película', 2006),
      (3, 'Tercera película', 2012),
      (4, 'Cuarta película', 2021),
      (5, 'Quinta película', 2024);
-- Ingreso de valores de la tabla tags
INSERT INTO
       tags (id, tag)
VALUES
      (6476, 'Acción y aventura'),
      (5763, 'Drama'),
      (6548, 'Comedias'),
      (8711, 'Terror y suspenso'),
      (0783, 'Niños y familia');
-- Ingreso de relaciones de películas y tags
INSERT INTO
       pelicula_tag(pelicula_id, tag_id)
VALUES
      (1, 6476),
      (1, 6548),
      (1, 783),
      (2, 5763),
      (2, 8711);
-- 3. Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe
-- mostrar 0.

SELECT 
  p.id,
  p.nombre AS pelicula,
  COUNT(pt.tag_id) AS cantidad_tags
FROM 
  peliculas p
LEFT JOIN 
  pelicula_tag pt ON p.id = pt.pelicula_id
GROUP BY 
  p.id, p.nombre
ORDER BY
   COUNT(p.id) DESC, p.id ASC;
-- Dado el modelo:
-- 4. Crea las tablas correspondientes respetando los nombres, tipos, claves primarias y
--    foráneas y tipos de datos.
-- Creacion de tabla peliculas
CREATE TABLE preguntas(
  id INT primary key,
  pregunta VARCHAR(255),  
  respuesta_correcta VARCHAR 
  );
-- Creacion de tabla usuarios
CREATE TABLE usuarios(
  id INT primary key,
  nombre VARCHAR(255),
  edad INT
  );
-- Creacion de tabla respuestas
CREATE TABLE respuestas(
  respuestas_id INT,
  respuesta VARCHAR(255),
  usuario_id INT,
  pregunta_id INT,
  FOREIGN KEY (usuario_id) REFERENCES usuarios (id),
  FOREIGN KEY (pregunta_id) REFERENCES preguntas (id)
);
-- 5. Agrega 5 usuarios y 5 preguntas.
-- a. La primera pregunta debe estar respondida correctamente dos veces, por dos
--    usuarios diferentes.
-- b. La segunda pregunta debe estar contestada correctamente solo por un
--    usuario.
-- c. Las otras tres preguntas deben tener respuestas incorrectas.
--    Contestada correctamente significa que la respuesta indicada en la tabla respuestas
--    es exactamente igual al texto indicado en la tabla de preguntas.
INSERT INTO
       preguntas (id, pregunta, respuesta_correcta)
VALUES
      (1, '¿Quién es el dios del trueno en la mitología nórdica', 'Thor'),
      (2, '¿Cual es el nombre del río que los muertos deben cruzar en la mitologías griega?', 'Estigia'),
      (3, '¿Quién es la diosa del amor y la belleza en la mitología romana?', 'Venus'),
      (4, '¿Qué criatura mitológica tiene cabeza de león, cuerpo de cabra y cola de serpiente?', 'Quimera'),
      (5, '¿Quién es el dios del sol en la mitología egipcia?', 'Ra');
-- Ingreso de valores de la tabla usuarios
INSERT INTO
       usuarios (id, nombre, edad)
VALUES
      (1, 'Víctor Velásquez', 21),
      (2, 'Juan Guzmán', 25),
      (3, 'Oscar Choy', 19),
      (4, 'José Arca', 23),
      (5, 'Alfonso Villanueva', 26);
-- Ingreso de relaciones entre preguntas y sus respuestas
INSERT INTO respuestas (respuestas_id, respuesta, usuario_id, pregunta_id)
VALUES
  -- Primera pregunta respondida correctamente dos veces
  (1, 'Thor', 1, 1),
  (2, 'Thor', 5, 1),
  -- Segunda pregunta respondida correctamente una vez
  (3, 'Estigia', 2, 2),
  -- Tercera pregunta respondida incorrectamente
  (4, 'Afrodita', 4, 3),
  -- Cuarta pregunta respondida incorrectamente
  (5, 'Minotauro', 3, 4),
  -- Quinta pregunta respondida incorrectamente
  (6, 'Apolo', 1, 5);

-- DELETE FROM respuestas;
-- 6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la
--    pregunta).
--    Respuesta al requerimiento 6:  
SELECT
    usuarios.id,
    usuarios.nombre,
    count(DISTINCT respuestas.usuario_id) AS Nro_Respuestas_Correctas    
FROM 
    respuestas
LEFT JOIN 
    preguntas ON preguntas.id = respuestas.pregunta_id
RIGHT JOIN 
    usuarios ON respuestas.usuario_id = usuarios.id AND preguntas.respuesta_correcta = respuestas.respuesta
GROUP BY
    usuarios.id, usuarios.nombre, respuestas.usuario_id
ORDER BY 
    usuarios.id;   

-- 7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron
--    correctamente.
SELECT
    p.id,
    p.pregunta,
    p.respuesta_correcta,
    COUNT(DISTINCT r.usuario_id) AS nro_usuarios_r_correctas
FROM 
    preguntas p
LEFT JOIN 
    respuestas r ON p.id = r.pregunta_id AND r.respuesta = p.respuesta_correcta
GROUP BY 
    p.id, p.pregunta, r.respuesta
ORDER BY 
    p.id;

-- 8. Implementa un borrado en cascada de las respuestas al borrar un usuario. Prueba la
--    implementación borrando el primer usuario.
-- 8.1  Borrado de la llave foranea y creacion de la misma llave pero con borrado en cascada]
ALTER TABLE respuestas DROP CONSTRAINT respuestas_usuario_id_fkey, ADD FOREIGN KEY
(usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE;
-- 8.2  Prueba con el usuario 1
DELETE FROM usuarios WHERE id = 1;
-- Mostrar como queda usuarios y respuestas
-- 9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de
--datos.
ALTER TABLE usuarios ADD CONSTRAINT check_edad CHECK (edad >= 18);
INSERT INTO
       usuarios (id, nombre, edad)
VALUES
      (1, 'Víctor Velásquez', 17);

--10. Altera la tabla existente de usuarios agregando el campo email. Debe tener la
--    restricción de ser único.
ALTER TABLE usuarios DROP email;
ALTER TABLE usuarios
ADD COLUMN email VARCHAR(255) UNIQUE;

