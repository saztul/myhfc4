#!/bin/bash
printf "

source general
{

    type     = mysql
    sql_host = myhfc4-database
    sql_user = $MYSQL_USER
    sql_pass = $MYSQL_PASSWORD
    sql_db   = $MYSQL_DATABASE
    sql_port = 3306    # optional, default is 3306

    sql_query_pre = SET NAMES utf8

    sql_query = SELECT * FROM sphinx_search
    sql_field_string        = title
    sql_field_string        = content

    sql_attr_string         = scope
    sql_attr_string         = tab
    sql_attr_string         = image
    sql_attr_string         = id_result
    sql_attr_uint           = id_client
    sql_attr_timestamp      = ts
}

index general
{
    source                  = general
    path                    = /var/sphinx/general/view-index
    dict                    = keywords
    ondisk_attrs            = pool
    min_word_len            = 3
    min_infix_len           = 2
    html_strip              = 1
    blend_chars             = ., -
    charset_table           = 0..9, A..Z->a..z, _, a..z, U+410..U+42F->U+430..U+44F, U+430..U+44F,U+C5->U+E5, \
                              U+E5, U+C4->U+E4, U+E4, U+D6->U+F6, U+F6, U+16B, U+0c1->a, U+0c4->a, U+0c9->e, U+0cd->i, \
                              U+0d3->o, U+0d4->o, U+0da->u, U+0dd->y, U+0e1->a, U+0e4->a, U+0e9->e, U+0ed->i, U+0f3->o, \
                              U+0f4->o, U+0fa->u, U+0fd->y, U+104->U+105, U+105, U+106->U+107, U+10c->c, U+10d->c, \
                              U+10e->d, U+10f->d, U+116->U+117, U+117, U+118->U+119, U+11a->e, U+11b->e, U+12E->U+12F, \
                              U+12F, U+139->l, U+13a->l, U+13d->l, U+13e->l, U+141->U+142, U+142, U+143->U+144, \
                              U+144,U+147->n, U+148->n, U+154->r, U+155->r, U+158->r, U+159->r, U+15A->U+15B, U+15B, \
                              U+160->s, U+160->U+161, U+161->s, U+164->t, U+165->t, U+16A->U+16B, U+16B, U+16e->u, \
                              U+16f->u, U+172->U+173, U+173, U+179->U+17A, U+17A, U+17B->U+17C, U+17C, U+17d->z, \
                              U+17e->z, U+DC->U+FC, U+DF, U+FC
}

indexer
{
    mem_limit    = 1024M
}


searchd
{
    listen           = localhost:9313
    listen           = localhost:9307:mysql41
    log              = /var/sphinx/logs/general-searchd.log
    query_log        = /var/sphinx/logs/general-query.log
    pid_file         = /var/sphinx/logs/general-searchd.pid
    binlog_path      = /var/sphinx/general/
    read_timeout     = 5
    max_children     = 30
    seamless_rotate  = 1
    preopen_indexes  = 0
    unlink_old       = 1
    collation_server = utf8_general_ci
    workers          = threads # for RT to work
}
"