CREATE OR REPLACE PROCEDURE verify_game_integrity(p_game INT)
AS $$
DECLARE
    var_exists BOOL;
    var_det BOOL;
    var_cat INT;
    var_gen INT;
    var_lang INT;
    var_os INT;
    var_dev INT;
    var_pub INT;
    var_tag INT;
BEGIN

    -- Verificar existência do jogo
    SELECT EXISTS(SELECT 1 FROM games WHERE appid = p_game) INTO var_exists;

    IF NOT var_exists THEN
        RAISE EXCEPTION 'O jogo % não existe na tabela games.', p_game;
    END IF;

    -- Verificar existência dos detalhes
    SELECT EXISTS(SELECT 1 FROM detalhes WHERE id_game = p_game) INTO var_det;

    IF NOT var_det THEN
        RAISE NOTICE 'AVISO: Jogo % não possui entrada na tabela detalhes.', p_game;
    ELSE
        RAISE NOTICE 'Detalhes encontrados para o jogo %.', p_game;
    END IF;

  
    -- Contar categorias, gêneros, idiomas, sistemas operacionais
    SELECT COUNT(*) INTO var_cat FROM categories_game WHERE id_game = p_game;
    SELECT COUNT(*) INTO var_gen FROM genres_game WHERE id_game = p_game;
    SELECT COUNT(*) INTO var_lang FROM languages_game WHERE id_game = p_game;
    SELECT COUNT(*) INTO var_os FROM operation_systems_games WHERE id_game = p_game;

    RAISE NOTICE 'Categorias encontradas: %', var_cat;
    IF var_cat = 0 THEN
        RAISE NOTICE 'AVISO: Jogo % não possui categorias.', p_game;
    END IF;

    RAISE NOTICE 'Gêneros encontrados: %', var_gen;
    IF var_gen = 0 THEN
        RAISE NOTICE 'AVISO: Jogo % não possui gêneros.', p_game;
    END IF;

    RAISE NOTICE 'Idiomas encontrados: %', var_lang;
    IF var_lang = 0 THEN
        RAISE NOTICE 'AVISO: Jogo % não possui idiomas cadastrados.', p_game;
    END IF;

    RAISE NOTICE 'Sistemas operacionais encontrados: %', var_os;
    IF var_os = 0 THEN
        RAISE NOTICE 'AVISO: Jogo % não possui sistemas operacionais cadastrados.', p_game;
    END IF;


    -- Contar developers, publishers e tags
    SELECT COUNT(*) INTO var_dev FROM developers_game WHERE id_game = p_game;
    SELECT COUNT(*) INTO var_pub FROM publishers_game WHERE id_game = p_game;
    SELECT COUNT(*) INTO var_tag FROM tags_game WHERE id_game = p_game;

    RAISE NOTICE 'Developers encontrados: %', var_dev;
    IF var_dev = 0 THEN
        RAISE NOTICE 'AVISO: Jogo % não possui desenvolvedores vinculados.', p_game;
    END IF;

    RAISE NOTICE 'Publishers encontrados: %', var_pub;
    IF var_pub = 0 THEN
        RAISE NOTICE 'AVISO: Jogo % não possui publishers vinculados.', p_game;
    END IF;

    RAISE NOTICE 'Tags encontradas: %', var_tag;
    IF var_tag = 0 THEN
        RAISE NOTICE 'AVISO: Jogo % não possui tags cadastradas.', p_game;
    END IF;

    RAISE NOTICE 'Verificação completa concluída para o jogo %.', p_game;
END;
$$
LANGUAGE plpgsql;