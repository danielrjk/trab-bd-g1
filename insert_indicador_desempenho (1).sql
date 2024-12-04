WITH anos AS (
    SELECT generate_series(2016, 2024) AS ano
)
INSERT INTO indicador_desempenho (
    ano, 
    taxa_evasao, 
    taxa_conclusao, 
    percentual_bolsistas, 
    curso_nome, 
    curso_nome_ies, 
    curso_uf_ies, 
    curso_municipio_ies
)
SELECT 
    anos.ano,
    ROUND(
        (
            COUNT(CASE WHEN matriculas.status = 'Evasão' AND matriculas.ano_ingresso <= anos.ano THEN 1 END)
            * 100.0 / NULLIF(COUNT(matriculas.discente_id), 0)
        ), 2
    ) AS taxa_evasao,
    ROUND(
        (
            COUNT(CASE WHEN matriculas.status = 'Formado' AND matriculas.ano_conclusao = anos.ano THEN 1 END)
            * 100.0 / NULLIF(COUNT(matriculas.discente_id), 0)
        ), 2
    ) AS taxa_conclusao,
    ROUND(
        (
            COUNT(CASE WHEN matriculas.bolsista = TRUE THEN 1 END)
            * 100.0 / NULLIF(COUNT(matriculas.discente_id), 0)
        ), 2
    ) AS percentual_bolsistas,
    cursos.nome AS curso_nome,
    cursos.nome_ies,
    cursos.uf_ies,
    cursos.municipio_ies
FROM 
    anos
CROSS JOIN cursos
LEFT JOIN matriculas ON
    cursos.nome = matriculas.curso_nome AND
    cursos.nome_ies = matriculas.curso_nome_ies AND
    cursos.uf_ies = matriculas.curso_uf_ies AND
    cursos.municipio_ies = matriculas.curso_municipio_ies
    AND matriculas.ano_ingresso <= anos.ano
GROUP BY 
    anos.ano, cursos.nome, cursos.nome_ies, cursos.uf_ies, cursos.municipio_ies
ORDER BY 
    anos.ano, cursos.nome, cursos.nome_ies, cursos.uf_ies, cursos.municipio_ies;
