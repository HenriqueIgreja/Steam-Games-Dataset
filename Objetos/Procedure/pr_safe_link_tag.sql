CREATE OR REPLACE PROCEDURE pr_safe_link_tag(p_appid INT, p_tag_name TEXT)
AS $$
DECLARE
    var_tag_id INT;
    var_clean_tag TEXT;
BEGIN
    --Sanitização: Remove espaços e força minúsculo para evitar duplicatas visuais
    var_clean_tag := lower(trim(p_tag_name));

    --Verifica se a tag já existe
    SELECT id INTO var_tag_id
    FROM tags
    WHERE lower(tag_name) = var_clean_tag;

    --Se não existe, cria a tag na hora
    IF var_tag_id IS NULL THEN
        INSERT INTO tags (tag_name) VALUES (var_clean_tag)
        RETURNING id INTO var_tag_id;
        RAISE NOTICE 'Nova tag "%" criada no sistema.', var_clean_tag;
    END IF;

    --Tenta vincular ao jogo (com tratamento para evitar erro se já estiver vinculado)
    BEGIN
        INSERT INTO tags_game (id_tag, id_game)
        VALUES (var_tag_id, p_appid);
    EXCEPTION 
        WHEN unique_violation THEN
            RAISE NOTICE 'O jogo % já possui a tag "%". Nada a fazer.', p_appid, var_clean_tag;
    END;
END;
$$
LANGUAGE plpgsql;