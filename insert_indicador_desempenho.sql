WITH anos AS (
    SELECT generate_series(2016, 2024) AS ano
)

INSERT INTO indicador_desempenho (ano, taxa_evasao, taxa_conclusao, percentual_bolsistas, cursos_id)
SELECT 
    anos.ano,
    ROUND(
        (COUNT(CASE WHEN matriculas.status = 'Evasão' AND matriculas.ano_ingresso <= anos.ano THEN 1 ELSE NULL END) 
              * 100.0 / NULLIF(COUNT(matriculas.id), 0)), 2
    ) AS taxa_evasao,
    ROUND(
        (COUNT(CASE WHEN matriculas.status = 'Formado' AND matriculas.ano_conclusao = anos.ano THEN 1 ELSE NULL END) 
              * 100.0 / NULLIF(COUNT(matriculas.id), 0)), 2
    ) AS taxa_conclusao,
    ROUND(
        (COUNT(CASE WHEN matriculas.bolsista = TRUE THEN 1 ELSE NULL END) * 100.0 / NULLIF(COUNT(matriculas.id), 0)), 2
    ) AS percentual_bolsistas,
    cursos.id AS cursos_id
FROM 
    anos
CROSS JOIN cursos
LEFT JOIN matriculas ON cursos.id = matriculas.cursos_id
WHERE cursos.id IS NOT NULL
GROUP BY 
    anos.ano, cursos.id
ORDER BY 
    anos.ano, cursos.id;
