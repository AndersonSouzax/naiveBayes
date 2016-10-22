---------------------------------------------------------------
--FUNÇÃO PARA DETERMINAR A CLASSE A QUAL PERTENCE O INDIVIDUO--
---------------------------------------------------------------
IF EXISTS( SELECT OBJECT_ID('Iris.dbo.Treinamento','U') ) 
DROP FUNCTION dbo.Treinamento
GO
CREATE FUNCTION dbo.Treinamento (@TAM1 NUMERIC(5,2),@TAM2 NUMERIC(5,2),@TAM3 NUMERIC(5,2),@TAM4 NUMERIC(5,2)) RETURNS INT
AS 
BEGIN
DECLARE @Class INT = 1

DECLARE @Probab TABLE(
  Probabilidade NUMERIC(5,2),
  Cla INT
)


WHILE(@Class < 4) 
BEGIN

DECLARE @Media1 NUMERIC(10) = (SELECT AVG(A.C1) FROM Características A WHERE A.Classe = @Class)
DECLARE @Media2 NUMERIC(10)	= (SELECT AVG(A.C2) FROM Características A WHERE A.Classe = @Class)
DECLARE @Media3 NUMERIC(10)	= (SELECT AVG(A.C3) FROM Características A WHERE A.Classe = @Class)
DECLARE @Media4 NUMERIC(10)	= (SELECT AVG(A.C4) FROM Características A WHERE A.Classe = @Class)

DECLARE @V1 NUMERIC(5,2)  = (SELECT VARP(A.C1) FROM Características A WHERE A.Classe = @Class)
DECLARE @V2 NUMERIC(5,2)  = (SELECT VARP(A.C2) FROM Características A WHERE A.Classe = @Class)
DECLARE @V3 NUMERIC(5,2)  = (SELECT VARP(A.C3) FROM Características A WHERE A.Classe = @Class)
DECLARE @V4 NUMERIC(5,2)  = (SELECT VARP(A.C4) FROM Características A WHERE A.Classe = @Class)

DECLARE @D1 NUMERIC(5,2) = SQRT(@V1) 
DECLARE @D2 NUMERIC(5,2) = SQRT(@V2)
DECLARE @D3 NUMERIC(5,2) = SQRT(@V3)
DECLARE @D4 NUMERIC(5,2) = SQRT(@V4)

DECLARE @Dist1 NUMERIC(5,2) = (1/((SQRT(2*PI()))*@D1))*EXP(POWER((@TAM1-@Media1),2)*-1/(2*@D1))
DECLARE @Dist2 NUMERIC(5,2)	= (1/((SQRT(2*PI()))*@D2))*EXP(POWER((@TAM2-@Media2),2)*-1/(2*@D2))
DECLARE @Dist3 NUMERIC(5,2)	= (1/((SQRT(2*PI()))*@D3))*EXP(POWER((@TAM3-@Media3),2)*-1/(2*@D3))
DECLARE @Dist4 NUMERIC(5,2)	= (1/((SQRT(2*PI()))*@D4))*EXP(POWER((@TAM4-@Media4),2)*-1/(2*@D4))

INSERT INTO @Probab
VALUES
(ROUND(@Dist1,3) * ROUND(@Dist2,3) * ROUND(@Dist3,3) * ROUND(@Dist4,3), @Class)


SET @Class = @Class + 1

END

DECLARE @Res INT  = (SELECT A.Cla 
                     FROM @Probab A
                     WHERE A.Probabilidade = 
                              (SELECT MAX(B.Probabilidade) FROM @Probab B))

RETURN @Res
               
END

